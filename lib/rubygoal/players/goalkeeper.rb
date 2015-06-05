require 'rubygoal/players/average'

module Rubygoal
  class GoalKeeperPlayer < AveragePlayer

    def side_move_to(position)
      move_to(position)
      reset_rotation
    end
  end
end
