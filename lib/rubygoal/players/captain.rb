module Rubygoal
  class CaptainPlayer < Player
    def initialize(*args)
      super
      config = Rubygoal.configuration

      @type = :captain
      @error = config.captain_error
      @speed = config.captain_speed
    end

    protected

    def image_filename(side)
      File.dirname(__FILE__) + "/../../../media/captain_#{side}.png"
    end
  end
end
