require 'rubygoal/coach'
require 'rubygoal/formation'

module Rubygoal
  class CoachHome < Coach

    #team do
      #name "Wanderers"

      #primary_colors [:black, :white]
      #secondary_colors :red

      #players do
        #goalkeeper :goalkeeper

        #captain :captain

        #fast1 :fast
        #fast2 :fast
        #fast3 :fast

        #average1 :average
        #average2 :average
        #average3 :average
        #average4 :average
        #average5 :average
        #average6 :average
      #end
    #end

    def name
      "Wanderers"
    end

    def formation(match)
      formation = Formation.new

      if match.me.winning?
        formation.defenders :average1, :average2, :average3, :captain, :average4
        formation.midfielders :average5, :none, :fast1, :none, :average6
        formation.attackers :none, :fast2, :none, :fast3, :none
      elsif match.time < 20
        formation.defenders :none, :fast1, :average1, :average2, :none
        formation.midfielders :average3, :average4, :captain, :none, :average5
        formation.attackers :fast2, :none, :none, :fast3, :average6
      else
        # Mirror opponent players

        opponent = match.other.positions
        my_players = players.values.flatten

        opponent.each do |name, pos|
          formation.lineup do
            custom_position do
              player my_players.pop
              position pos.x, pos.y
            end
          end
        end
      end

      formation
    end
  end
end
