require 'rubygoal/coach_definition'
require 'rubygoal/formation'

module Rubygoal
  class OpalCoachDefinition < CoachDefinition

    def name
      js_coach.JS.name()
    end

    def players
      js_coach.JS.players().map do |player|
        name = player.JS[:name].to_sym
        type = player.JS[:type].to_sym

        PlayerDefinition.new(name, type)
      end
    end

    def formation(match)
      result = js_coach.JS.formation(
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

    private

    def js_coach
      raise "js_coach should be implemented by a subclass"
    end
  end
end
