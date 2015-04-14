module Rubygoal
  class MorePlayersCoachDefinition < CoachDefinition
    team do
      name "MorePlayers"

      players do
        captain :captain

        fast :fast1
        fast :fast2
        fast :fast3

        average :average1
        average :average2
        average :average3
        average :average4
        average :average5
        average :average6
        average :average7
      end
    end

    def formation(match)
      Formation.new
    end
  end
end
