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
        formation = mirror_formation(match.other.lineup)
      end

      formation
    end
  end
end
