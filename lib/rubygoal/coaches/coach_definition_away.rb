require 'rubygoal/coach_definition'
require 'rubygoal/formation'

module Rubygoal
  class CoachDefinitionAway < CoachDefinition

    team do
      name "Marruecos"
    end

    def formation(match)
      formation = Formation.new

      if match.me.winning?
        formation.lineup do
          defenders :average1, :fast1, :none, :fast3, :average5
          midfielders :average2, :none, :captain, :none, :average6
          att_midfielders :average3
          attackers :none, :none, :fast2, :average4, :none
        end
      elsif match.me.draw?
        formation.lineup do
          lines do
            defenders 13
            midfielders 40
            attackers 65
          end

          defenders :average1, :fast1, :none, :average3, :average5
          midfielders :average2, :none, :none, :none, :average6
          attackers :none, :fast2, :none, :average4, :none

          custom_position do
            player :fast3
            position 30, 10
          end
          custom_position do
            player :captain
            position 60, 50
          end
        end
      elsif match.me.losing?
        if match.time < 30
          formation.lineup do
            defenders :none, :average2, :average4, :average5, :none
            midfielders :average1, :none, :none, :fast2, :average6
            attackers :none, :average3, :none, :fast3, :none

            custom_position do
              player :fast1
              position 33, 50
            end
            custom_position do
              player :captain
              position 67, 50
            end
          end
        else
          formation.lineup do
            defenders :none, :average2, :fast1, :average5, :none
            def_midfielders :average4
            midfielders :average1, :none, :none, :captain, :average6
            att_midfielders :fast2
            attackers :none, :average3, :none, :fast3, :none
          end
        end
      end

      formation
    end
  end
end
