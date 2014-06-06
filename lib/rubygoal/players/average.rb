require 'rubygoal/team'

module Rubygoal
  class AveragePlayer < Player
    def initialize(*args)
      super
      config = Rubygoal.configuration
      error_range = config.average_lower_error..config.average_upper_error

      @error = Random.rand(error_range)
      @speed = config.average_speed
    end

    protected

    def image_filename(side)
      File.dirname(__FILE__) + "/../../../media/average_#{side}.png"
    end
  end

  GoalKeeperPlayer = AveragePlayer
end
