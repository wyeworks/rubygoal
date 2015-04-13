module Rubygoal
  class Formation
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
  end
end
