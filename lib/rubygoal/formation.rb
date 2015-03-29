module Rubygoal
  class Formation
    attr_accessor :players_position, :lines_definition

    def initialize
      @players_position = {}

      @lines_definition = {
        defenders: Field::WIDTH / 6,
        midfielders: Field::WIDTH / 2,
        attackers: Field::WIDTH / 6 * 5,
      }
    end

    def method_missing(method, *args)
      line_name = method.to_s.chomp('=').to_sym
      if lines_definition[line_name]
        set_players_in_custom_line(lines_definition[line_name], args.first)
      end
    end

    def lineup_for_opponent(players)
      positions = {
        captain: [],
        average: [],
        fast: []
      }

      players_position.each do |name, pos|
        player_type = players[name].type
        positions[player_type] << pos
      end

      positions
    end

    def errors
      errors = []

      # TODO Check if we need to count for the goalkeeper as well
      if players_position.size != 10
        errors << 'Incorrect number of players, are you missing a name?'
      end

      errors
    end

    def valid?
      errors.empty?
    end

    private

    def set_players_in_custom_line(position_x, players)
      base_position = Position.new(position_x, 0)
      separation = line_position_separation(players)

      players.each_with_index do |player, i|
        next if player == :none

        offset = Position.new(0, separation * (i + 1))
        position = base_position.add(offset)

        self.players_position[player] = position
      end
    end

    def line_position_separation(players)
      Field::HEIGHT / (players.size + 1)
    end
  end
end
