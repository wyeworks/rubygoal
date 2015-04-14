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
      else
        # Mirror opponent players

        opponent = match.other.positions
        my_players = players

        opponent.each_with_index do |(opponent_name, opponent_pos), index|
          formation.lineup do
            custom_position do
              player my_players[index].name
              position opponent_pos.x, opponent_pos.y
            end
          end
        end
      end

      formation
    end
  end
end
