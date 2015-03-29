module Rubygoal
  class Formation
    attr_accessor :players_position

    def initialize
      @players_position = {}

      @position_lines = {
        defenders:   Field::WIDTH / 6 - 30,
        midfielders: (Field::WIDTH / 6) * 3 - 30,
        attackers:   (Field::WIDTH / 6) * 5 - 30
      }
    end

    def defenders=(players)
      set_players_in_predefined_line(:defenders, players)
    end

    def midfielders=(players)
      set_players_in_predefined_line(:midfielders, players)
    end

    def attackers=(players)
      set_players_in_predefined_line(:attackers, players)
    end

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

    attr_accessor :position_lines

    def set_players_in_predefined_line(line, players)
      set_players_in_custom_line(position_lines[line], players)
    end

    def line_position_separation(players)
      Field::HEIGHT / (players.size + 1)
    end
  end
end
