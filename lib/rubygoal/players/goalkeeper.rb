require 'rubygoal/players/average'
require 'rubygoal/field'
require 'rubygoal/util'

module Rubygoal
  class GoalKeeperPlayer < AveragePlayer

    def move_to_cover_goal(ball)
      move_without_rotation_to(position_to_cover_goal(ball))
    end

    private

    def position_to_cover_goal(ball)
      Util.y_intercept_with_line(
        initial_position.x,
        Field.goal_position(side),
        ball.position
      )
    end

    def move_without_rotation_to(pos)
      move_to(pos)
      reset_rotation
    end
  end
end
