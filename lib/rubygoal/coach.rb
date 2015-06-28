require 'forwardable'

module Rubygoal
  class Coach
    extend Forwardable

    def_delegators :coach_definition, :players, :name, :formation

    def initialize(coach_definition)
      @coach_definition = coach_definition
    end

    def errors
      [].tap do |errors|
        check_unique_captain(errors)
        check_players_count(:average, errors)
        check_players_count(:fast, errors)
      end
    end

    def valid?
      errors.empty?
    end

    def players_by_type(type)
      players.select { |p| p.type == type }
    end

    def captain_player
      players_by_type(:captain).first
    end

    def fast_players
      players_by_type(:fast)
    end

    def average_players
      players_by_type(:average)
    end

    def initial_formation
      average_names = average_players.map(&:name)
      fast_names    = fast_players.map(&:name)
      captain_name  = captain_player.name

      formation = Formation.new

      formation.lineup do
        defenders average_names[0], average_names[2], :none, average_names[3], average_names[4]
        midfielders average_names[1], fast_names[0], :none, fast_names[1], average_names[5]
        attackers :none, captain_name, :none, fast_names[2], :none
      end

      formation
    end

    private

    attr_reader :coach_definition

    def game_config
      Rubygoal.configuration
    end

    def check_unique_captain(errors)
      captain_count = players_by_type(:captain).size

      if captain_count != 1
        errors << "The number of captains is #{captain_count}"
      end
    end

    def check_players_count(type, errors)
      players_count = players_by_type(type).size

      if players_count != game_config.send("#{type}_players_count")
        errors << "The number of #{type} players is #{players_count}"
      end
    end
  end
end
