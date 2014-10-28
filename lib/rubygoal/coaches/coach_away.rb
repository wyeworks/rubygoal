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
          [:average1, :none, :average2, :none,    :none],
          [:fast1,    :none, :none,    :average3, :none],
          [:none,    :none, :captain, :none,    :fast2],
          [:fast3,    :none, :none,    :none, :average4],
          [:average5, :none, :average6, :none,    :none],
        ]
      elsif match.me.draw?
        formation.lineup = [
          [:average1, :none, :average2, :none,    :none],
          [:fast1, :none, :none,    :none,    :fast2],
          [:none,    :fast3, :none,    :captain, :none],
          [:average3, :none, :none,    :none,    :average4],
          [:average5, :none, :average6, :none,    :none],
        ]
      elsif match.me.losing?
        if match.time < 30
          formation.lineup = [
            [:none,    :none, :average1, :none,    :none],
            [:average2, :none, :none,    :none,    :average3],
            [:average4, :fast1, :none,    :captain, :none],
            [:average5, :none, :fast2,    :none,    :fast3],
            [:none,    :none, :average6, :none,    :none],
          ]
        else
          formation.lineup = [
            [:none,    :none,    :average1, :none, :none],
            [:average2, :none,    :none,    :none, :average3],
            [:fast1,    :average4, :none,    :fast2, :none],
            [:average5, :none,    :captain, :none, :fast3],
            [:none,    :none,    :average6, :none, :none],
          ]
        end
      end

      formation
    end
  end
end
