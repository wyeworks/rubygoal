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
        formation.defenders = [:average, :average, :average, :captain, :average]
        formation.midfielders = [:average, :none, :fast, :none, :average]
        formation.attackers = [:none, :fast, :none, :fast, :none]
      elsif match.time < 20
        formation.defenders = [:none, :fast, :average, :average, :none]
        formation.midfielders = [:average, :average, :captain, :none, :average]
        formation.attackers = [:fast, :none, :none, :fast, :average]
      else
        formation.lineup = match.other.formation.lineup
      end

      formation
    end
  end
end
