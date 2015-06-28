module Rubygoal
  class ValidCoachDefinition < CoachDefinition
    team do
      name "ValidTeam"

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
      end
    end

    def formation(match)
      Formation.new
    end
  end
end
