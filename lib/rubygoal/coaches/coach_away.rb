require 'rubygoal/coach'
require 'rubygoal/formation'

module Rubygoal
  class CoachAway < Coach
    def name
      "Danubio"
    end

    def formation(match)
      formation = Formation.new

      if match.me.winning?
        formation.lineup = [
          [:average, :none, :average, :none,    :none],
          [:fast,    :none, :none,    :average, :none],
          [:none,    :none, :captain, :none,    :fast],
          [:fast,    :none, :none,    :none, :average],
          [:average, :none, :average, :none,    :none],
        ]
      elsif match.me.draw?
        formation.lineup = [
          [:average, :none, :average, :none,    :none],
          [:fast, :none, :none,    :none,    :fast],
          [:none,    :fast, :none,    :captain, :none],
          [:average, :none, :none,    :none,    :average],
          [:average, :none, :average, :none,    :none],
        ]
      elsif match.me.losing?
        if match.time < 30
          formation.lineup = [
            [:none,    :none, :average, :none,    :none],
            [:average, :none, :none,    :none,    :average],
            [:average, :fast, :none,    :captain, :none],
            [:average, :none, :fast,    :none,    :fast],
            [:none,    :none, :average, :none,    :none],
          ]
        else
          formation.lineup = [
            [:none,    :none,    :average, :none, :none],
            [:average, :none,    :none,    :none, :average],
            [:fast,    :average, :none,    :fast, :none],
            [:average, :none,    :captain, :none, :fast],
            [:none,    :none,    :average, :none, :none],
          ]
        end
      end

      formation
    end
  end
end
