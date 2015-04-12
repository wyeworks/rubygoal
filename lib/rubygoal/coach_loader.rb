require 'rubygoal/coach'
require 'rubygoal/coaches/coach_definition_home'
require 'rubygoal/coaches/coach_definition_away'

module Rubygoal
  class CoachLoader
    DEFAULT_COACH_DEFINITIONS = {
      home: CoachDefinitionHome,
      away: CoachDefinitionAway
    }

    def initialize(side)
      @side = side
    end

    def coach
      Coach.new(load_definition_coach)
    end

    private

    attr_reader :side

    def default_definition_class
      DEFAULT_COACH_DEFINITIONS[side]
    end

    def load_definition_coach
      if filename && File.exists?(filename)
        load filename

        class_name = camelize(File.basename(filename, ".rb"))
        Rubygoal.const_get(class_name).new
      else
        if filename && Rubygoal.configuration.debug_output
          puts "File `#{filename}` doesn't exist. Using #{default_definition_class.name}."
        end

        default_definition_class.new
      end
    end

    def filename
      side == :home ? ARGV[0] : ARGV[1]
    end

    def camelize(term)
      string = term.to_s
      string = string.sub(/^[a-z\d]*/) { $&.capitalize }
      string.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
      string.gsub!('/', '::')
      string
    end
  end
end
