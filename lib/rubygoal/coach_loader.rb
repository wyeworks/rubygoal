module Rubygoal
  module CoachLoader
    class << self
      def get(default)
        file = ARGV.shift

        if file && File.exists?(file)
          load file

          class_name = camelize(File.basename(file, ".rb"))
          Rubygoal.const_get(class_name).new
        else
          if file
            puts "File `#{file}` doesn't exist. Using #{default.name}."
          end

          default.new
        end
      end

      private

      def camelize(term)
        string = term.to_s
        string = string.sub(/^[a-z\d]*/) { $&.capitalize }
        string.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
        string.gsub!('/', '::')
        string
      end
    end
  end
end
