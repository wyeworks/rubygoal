require 'forwardable'

require 'rubygoal/ball'
require 'rubygoal/coach_loader'
require 'rubygoal/teams/home'
require 'rubygoal/teams/away'
require 'rubygoal/match'
require 'rubygoal/coaches/coach_home'
require 'rubygoal/coaches/coach_away'

module Rubygoal
  class Field
    @width                  = 1394
    @height                 = 938
    @offset                 = Position.new(262, 112)
    @goal_height            = 275
    @close_to_goal_distance = 275

    class << self

      attr_reader :width, :height, :offset,
                  :goal_height, :close_to_goal_distance

      def center_position
        center = Position.new(
          width / 2,
          height / 2
        )
        offset.add(center)
      end

      def goal_position(side)
        position = center_position
        case side
        when :home
          position.x = offset.x
        when :away
          position.x = offset.x + width
        end
        position
      end

      def absolute_position(field_position, side)
        case side
        when :home
          offset.add(field_position)
        when :away
          offset.add(
            Position.new(
              width - field_position.x,
              height - field_position.y
            )
          )
        end
      end

      def position_side(position)
        position.x < center_position.x ? :home : :away
      end

      def out_of_bounds_width?(position)
        lower_limit = offset.x
        upper_limit = offset.x + width
        !(lower_limit..upper_limit).include?(position.x)
      end

      def out_of_bounds_height?(position)
        lower_limit = offset.y
        upper_limit = offset.y + height
        !(lower_limit..upper_limit).include?(position.y)
      end

      def goal?(position)
        if out_of_bounds_width?(position)
          lower_limit = center_position.y - goal_height / 2
          upper_limit = center_position.y + goal_height / 2

          (lower_limit..upper_limit).include?(position.y)
        else
          false
        end
      end

      def close_to_goal?(position, side)
        goal_position = Field.goal_position(side)
        goal_position.distance(position) < close_to_goal_distance
      end
    end
  end
end
