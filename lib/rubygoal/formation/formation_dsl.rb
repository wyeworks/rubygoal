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
        100.0
      end

      def field_height
        100.0
      end
    end

    class CustomLines < FormationDSL
      def initialize(formation)
        @formation = formation
        @lines = {}
      end

      def apply
        formation.lines_definition.each do |line_name, line_definition|
          if lines[line_name]
            formation.lines_definition[line_name][:position] = lines[line_name][:position]
            lines.delete(line_name)
          end
        end

        formation.lines_definition.merge!(lines)
      end

      private

      attr_reader :formation, :lines

      def method_missing(method, *args)
        define_line(method, args.first)
      end

      def define_line(name, x_position)
        lines[name] = { position: x_position / 100.0 * Field::WIDTH }
      end
    end

    class CustomPosition < FormationDSL
      def initialize(formation)
        @formation = formation
      end

      def apply
        formation.players_position[player_name] = player_position

        formation.lines_definition.each do |line_name, line_definition|
          formation.lines_definition[line_name][:players].delete(player_name)
        end
      end

      private

      attr_reader :formation
      attr_accessor :player_name, :player_position

      def player(name)
        self.player_name = name
      end

      def position(x, y)
        self.player_position = Field.position_from_percentages(Position.new(x, y))
      end
    end
  end
end
