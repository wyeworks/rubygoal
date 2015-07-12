module Rubygoal
  class TestHomeCoachDefinition < CoachDefinition
    team do
      name "Test Home Team"

      players do
        captain :home_captain

        fast :home_fast1
        fast :home_fast2
        fast :home_fast3

        average :home_average1
        average :home_average2
        average :home_average3
        average :home_average4
        average :home_average5
        average :home_average6
      end
    end

    def formation(match)
      formation = Formation.new

      formation.lineup do
        defenders :home_average1, :home_fast1, :none, :home_fast3, :home_average5
        midfielders :home_average2, :none, :home_captain, :none, :home_average6
        attackers :none, :home_average3, :home_fast2, :home_average4, :none
      end

      formation
    end
  end
end
