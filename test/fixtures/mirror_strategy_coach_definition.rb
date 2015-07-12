module Rubygoal
  class MirrorStrategyCoachDefinition < CoachDefinition
    team do
      name "Mimic Team"

      players do
        average :average1
        average :average2
        average :average3
        average :average4
        average :average5
        average :average6

        fast :fast1
        fast :fast2
        fast :fast3

        captain :captain
      end
    end

    def formation(match)
      # Mirror opponent players

      formation = Formation.new

      opponent = match.other.positions
      my_players = players

      opponent.each_with_index do |(_, opponent_pos), index|
        formation.lineup do
          custom_position do
            player my_players[index].name
            position opponent_pos.x, 100.0 - opponent_pos.y
          end
        end
      end

      formation
    end
  end
end
