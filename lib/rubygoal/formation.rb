module Rubygoal
  class Formation
    attr_accessor :players_position, :lines_definition

    class FormationDSL
      def self.apply(formation, &block)
        dsl = self.new(formation)
        dsl.instance_eval(&block)
        dsl.apply
      end

      private

      def field_width
        Field::WIDTH
      end

      def field_height
        Field::HEIGHT
      end
    end

    class CustomLines < FormationDSL
      def initialize(formation)
        @formation = formation
        @lines = {}
      end

      def apply
        formation.lines_definition.merge!(lines)
      end

      private

      attr_reader :formation, :lines

      def method_missing(method, *args)
        define_line(method, args.first)
      end

      def define_line(name, position)
        lines[name] = position
      end
    end

    class CustomPosition < FormationDSL
      def initialize(formation)
        @formation = formation
      end

      def apply
        formation.players_position[player_name] = player_position
      end

      private

      attr_reader :formation
      attr_accessor :player_name, :player_position

      def player(name)
        self.player_name = name
      end

      def position(x, y)
        self.player_position = Position.new(x, y)
      end
    end

    def initialize
      @players_position = {}

      @lines_definition = {
        defenders: Field::WIDTH / 6,
        def_midfielders: Field::WIDTH / 3,
        midfielders: Field::WIDTH / 2,
        att_midfielders: Field::WIDTH / 3 * 2,
        attackers: Field::WIDTH / 6 * 5,
      }
    end

    def method_missing(method, *args)
      line_name = method.to_s.chomp('=').to_sym
      if lines_definition[line_name]
        set_players_in_custom_line(lines_definition[line_name], args)
      end
    end

    def lineup(&block)
      instance_eval(&block)
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

    def lines(&block)
      CustomLines.apply(self, &block)
    end

    def custom_position(&block)
      CustomPosition.apply(self, &block)
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

    def line_position_separation(players)
      Field::HEIGHT / (players.size + 1)
    end
  end
end
