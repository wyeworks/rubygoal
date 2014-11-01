require 'rubygoal/coach'
require 'rubygoal/formation'

module Rubygoal
  class CoachHome < Coach

    def name
      "Wanderers"
    end

    def formation(match)
      formation = Formation.new

      if match.me.winning?
        formation.defenders = [:average1, :average2, :average3, :captain, :average4]
        formation.midfielders = [:average5, :none, :fast1, :none, :average6]
        formation.attackers = [:none, :fast2, :none, :fast3, :none]
      elsif match.time < 20
        formation.defenders = [:none, :fast1, :average1, :average2, :none]
        formation.midfielders = [:average3, :average4, :captain, :none, :average5]
        formation.attackers = [:fast2, :none, :none, :fast3, :average6]
      else
        formation.lineup = match.other.formation.lineup
        average_counter = -1
        fast_counter = -1
        5.times do |i|
          5.times do |j|
            case formation.lineup[i][j]
            when :average
              formation.lineup[i][j] = players[:average][average_counter+=1]
            when :fast
              formation.lineup[i][j] = players[:fast][fast_counter+=1]
            when :captain
              formation.lineup[i][j] = players[:captain][0]
            end
          end
        end
      end

      formation
    end
  end
end
