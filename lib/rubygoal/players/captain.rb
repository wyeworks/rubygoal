module Rubygoal
  class CaptainPlayer < Player
    def initialize(*args)
      super
      config = Rubygoal.configuration

      @error = config.captain_error
      @speed = config.captain_speed

      @type = :captain
    end
  end
end
