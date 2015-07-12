module Rubygoal
  class TestAwayCoachDefinition < CoachDefinition
    team do
      name "Test Away Team"

      players do
        captain :away_captain

        fast :away_fast1
        fast :away_fast2
        fast :away_fast3

        average :away_average1
        average :away_average2
        average :away_average3
        average :away_average4
        average :away_average5
        average :away_average6
      end
    end

    def formation(match)
      formation = Formation.new

      formation.lineup do
        defenders :away_average1, :away_fast1, :none, :away_fast3, :away_average5
        midfielders :away_average2, :away_average3, :away_captain, :away_average4, :away_average6
        attackers :none, :none, :away_fast2, :none, :none
      end

      formation
    end
  end
end
