require 'rubygoal/coach_definition'
require 'rubygoal/formation'

module Rubygoal
  class CoachDefinitionAway < CoachDefinition

    def self.js_coach
      `WyeGoal.awayCoach`
    end

    team do
      name js_coach.JS[:name]

      players do
        js_coach.JS[:players].each do |player|
          player_name = player.JS[:name].to_sym
          case player.JS[:type]
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
      result = self.class.js_coach.JS.formation(
        %x{
          {
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
          }
        }
      )

      formation = Formation.new
      formation.defenders(*(result.JS[:defenders].map(&:to_sym)))
      formation.midfielders(*(result.JS[:midfielders].map(&:to_sym)))
      formation.attackers(*(result.JS[:attackers].map(&:to_sym)))

      formation
    end

  end
end
