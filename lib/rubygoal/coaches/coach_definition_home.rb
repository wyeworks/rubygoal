require 'rubygoal/coach_definition'
require 'rubygoal/coaches/opal_coach_definition'

module Rubygoal
  class CoachDefinitionHome < OpalCoachDefinition

    private

    def js_coach
      `WyeGoal.homeCoach`
    end
  end
end
