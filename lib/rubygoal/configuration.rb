require 'rubygoal/coordinate'

module Rubygoal
  class Configuration
    attr_accessor :average_players_count, :fast_players_count, :captain_players_count,
                  :kick_strength, :kick_again_delay, :distance_control_ball,
                  :initial_player_positions, :game_time,
                  :average_lower_error, :average_upper_error, :average_speed,
                  :fast_lower_error, :fast_upper_error, :fast_speed,
                  :captain_error, :captain_speed
  end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end

  Rubygoal.configure do |config|
    config.average_players_count = 6
    config.fast_players_count    = 3
    config.captain_players_count = 1

    config.kick_strength         = 20
    config.kick_again_delay      = 60
    config.distance_control_ball = 30

    config.average_lower_error   = 0.1
    config.average_upper_error   = 0.15
    config.average_speed         = 3.5

    config.fast_lower_error      = 0.1
    config.fast_upper_error      = 0.15
    config.fast_speed            = 4

    config.captain_error         = 0.05
    config.captain_speed         = 4.5

    config.game_time             = 120
  end
end
