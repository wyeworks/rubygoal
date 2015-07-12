require 'forwardable'

require 'rubygoal/ball'
require 'rubygoal/coach_loader'
require 'rubygoal/teams/home'
require 'rubygoal/teams/away'
module Rubygoal
  module Field
    WIDTH               = 1394.0
    HEIGHT              = 938.0
    OFFSET              = Position.new(262, 112)
    GOAL_HEIGHT         = 275
    CLOSE_GOAL_DISTANCE = 275

    class << self
      def center_position
        center = Position.new(
          WIDTH / 2,
          HEIGHT / 2
        )
        OFFSET.add(center)
      end

      def goal_position(side)
        position = center_position
        case side
        when :home
          position.x = OFFSET.x
        when :away
          position.x = OFFSET.x + WIDTH
        end

        position
      end

      def absolute_position(field_position, side)
        case side
        when :home
          OFFSET.add(field_position)
        when :away
          OFFSET.add(
            Position.new(
              WIDTH - field_position.x,
              HEIGHT - field_position.y
            )
          )
        end
      end

      def field_position(absolute_position, side)
        case side
        when :home
          absolute_position.add(
            Position.new(
              - OFFSET.x,
              - OFFSET.y
            )
          )
        when :away
          Position.new(
            WIDTH - (absolute_position.x - OFFSET.x),
            HEIGHT - (absolute_position.y - OFFSET.y)
          )
        end
      end

      def position_from_percentages(position_in_percentages)
        Position.new(
          position_in_percentages.x / 100.0 * Field::WIDTH,
          position_in_percentages.y / 100.0 * Field::HEIGHT
        )
      end

      def position_to_percentages(position)
        Position.new(
          position.x / Field::WIDTH * 100,
          position.y / Field::HEIGHT * 100
        )
      end

      def position_side(position)
        position.x < center_position.x ? :home : :away
      end

      def out_of_bounds_width?(position)
        lower_limit = OFFSET.x
        upper_limit = OFFSET.x + WIDTH
        !(lower_limit..upper_limit).include?(position.x)
      end

      def out_of_bounds_height?(position)
        lower_limit = OFFSET.y
        upper_limit = OFFSET.y + HEIGHT
        !(lower_limit..upper_limit).include?(position.y)
      end

      def goal?(position)
        if out_of_bounds_width?(position)
          lower_limit = center_position.y - GOAL_HEIGHT / 2
          upper_limit = center_position.y + GOAL_HEIGHT / 2

          (lower_limit..upper_limit).include?(position.y)
        else
          false
        end
      end

      def close_to_goal?(position, side)
        goal_position = Field.goal_position(side)
        goal_position.distance(position) < CLOSE_GOAL_DISTANCE
      end

      def default_player_field_positions
        [
          Position.new(50, 469),
          Position.new(236, 106),
          Position.new(236, 286),
          Position.new(236, 646),
          Position.new(236, 826),
          Position.new(436, 106),
          Position.new(436, 286),
          Position.new(436, 646),
          Position.new(436, 826),
          Position.new(616, 436),
          Position.new(616, 496)
        ]
      end
    end
  end
end
