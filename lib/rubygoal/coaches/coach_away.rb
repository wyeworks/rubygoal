require 'rubygoal/coach'
require 'rubygoal/formation'

module Rubygoal
  class CoachAway < Coach

    def name
      "Danubio"
    end

    def formation(match)
      formation = Formation.new

      formation.lines_definition = {
        defenders: Field::WIDTH / 6,
        def_midfielders: Field::WIDTH / 3,
        midfielders: Field::WIDTH / 2,
        att_midfielders: Field::WIDTH / 3 * 2,
        attackers: Field::WIDTH / 6 * 5,
      }

      if match.me.winning?
        formation.defenders = [:average1, :fast1, :none, :fast3, :average5]
        formation.midfielders = [:average2, :none, :captain, :none, :average6]
        formation.att_midfielders = [:average3]
        formation.attackers = [:none, :none, :fast2, :average4, :none]
      elsif match.me.draw?
        formation.defenders = [:average1, :fast1, :none, :average3, :average5]
        formation.def_midfielders =  [:none, :none, :fast3, :none, :none]
        formation.midfielders = [:average2, :none, :none, :none, :average6]
        formation.att_midfielders = [:none, :none, :captain, :none, :none]
        formation.attackers = [:none, :fast2, :none, :average4, :none]
      elsif match.me.losing?
        if match.time < 30
          formation.defenders = [:none, :average2, :average4, :average5, :none]
          formation.def_midfielders = [:fast1]
          formation.midfielders = [:average1, :none, :none, :fast2, :average6]
          formation.att_midfielders = [:captain]
          formation.attackers = [:none, :average3, :none, :fast3, :none]
        else
          formation.defenders = [:none, :average2, :fast1, :average5, :none]
          formation.def_midfielders = [:average4]
          formation.midfielders = [:average1, :none, :none, :captain, :average6]
          formation.att_midfielders = [:fast2]
          formation.attackers = [:none, :average3, :none, :fast3, :none]
        end
      end

      formation
    end
  end
end
