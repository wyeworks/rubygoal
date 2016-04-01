require 'rubygoal/coach_definition'
require 'rubygoal/formation'

module Rubygoal

  class CoachDefinitionHome < CoachDefinition

    team do
      name `JSGoal.HomeCoachDefinition.name`

      players do
        10.times do |i|
          player_name = `JSGoal.HomeCoachDefinition.players[#{i}].name`.to_sym
          case `JSGoal.HomeCoachDefinition.players[#{i}].type`
          when 'captain'
            captain player_name
          when 'fast'
            fast player_name
          when 'average'
            average player_name
          end
        end
      end
    end

    def formation(match)
      result = %x{
        JSGoal.HomeCoachDefinition.formation({
          me: {
            winning: #{match.me.winning?},
            losing: #{match.me.losing?},
            drawing: #{match.me.draw?}
          },
          other: {
            winning: #{match.other.winning?},
            losing: #{match.other.losing?},
            drawing: #{match.other.draw?}
          },
          ball: {
            x: #{match.ball.x},
            y: #{match.ball.y}
          }
        });
      }

      formation = Formation.new
      formation.defenders(*(result.JS[:defenders].map(&:to_sym)))
      formation.midfielders(*(result.JS[:midfielders].map(&:to_sym)))
      formation.attackers(*(result.JS[:attackers].map(&:to_sym)))

      formation
    end

  end
end
