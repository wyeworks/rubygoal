module Rubygoal
  class FastPlayer < Player
    def initialize(*args)
      super
      config = Rubygoal.configuration
      error_range = config.fast_lower_error..config.fast_upper_error

      @error = Random.rand(error_range)
      @speed = config.fast_speed
    end

    protected

    def image_filename(side)
      File.dirname(__FILE__) + "/../../../media/fast_#{side}.png"
    end
  end
end
