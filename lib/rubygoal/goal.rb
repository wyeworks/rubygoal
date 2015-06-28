require 'rubygoal/configuration'

module Rubygoal
  class Goal
    def initialize
      @celebration_time = 0
    end

    def celebrating?
      celebration_time > 0
    end

    def start_celebration
      self.celebration_time = 3
    end

    def update(elapsed_time)
      start_celebration unless celebrating?
      self.celebration_time -= elapsed_time
    end

    protected

    attr_accessor :celebration_time
  end
end
