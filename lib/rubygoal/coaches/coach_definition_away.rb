require 'rubygoal/coaches/opal_coach_definition'

module Rubygoal
  class CoachDefinitionAway < OpalCoachDefinition

    private

    def js_coach
      `WyeGoal.awayCoach`
    end
  end
end
