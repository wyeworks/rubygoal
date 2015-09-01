require 'rubygoal/coach_definition'
require 'rubygoal/formation'

module Rubygoal
  class CoachDefinitionHome < CoachDefinition

    team do
      name "Uruguay"

      players do
        captain :godin

        fast :cavani
        fast :rolan
        fast :suarez

        average :pereira
        average :gimenez
        average :arevalo
        average :lodeiro
        average :cacerez
        average :rodriguez
      end
    end

    def formation(match)
      formation = Formation.new

      if match.me.winning?
        formation.defenders :pereira, :cacerez, :gimenez, :godin, :rodriguez
        formation.midfielders :lodeiro, :none, :rolan, :none, :arevalo
        formation.attackers :none, :cavani, :none, :suarez, :none
      elsif match.time < 20
        formation.defenders :none, :rolan, :cacerez, :gimenez, :none
        formation.midfielders :arevalo, :lodeiro, :godin, :none, :pereira
        formation.attackers :suarez, :none, :none, :cavani, :rodriguez
      elsif match.time < 20 && match.me.winning?
        # Mirror opponent players

        opponent = match.other.positions
        my_players = players

        opponent.each_with_index do |(opponent_name, opponent_pos), index|
          formation.lineup do
            custom_position do
              player my_players[index].name
              position opponent_pos.x, 100.0 - opponent_pos.y
            end
          end
        end
      else
        formation.lineup do
          if match.ball.x < 50
            lines do
              defenders 10
              midfielders 30
              attackers 50
            end
          else
            lines do
              defenders 30
              midfielders 50
              attackers 70
            end
          end

          defenders :pereira, :cacerez, :gimenez, :godin, :rodriguez
          midfielders :lodeiro, :none, :rolan, :none, :arevalo
          attackers :none, :cavani, :none, :suarez, :none
        end
      end

      formation
    end
  end
end
