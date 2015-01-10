require 'test_helper'

require 'rubygoal/formation'

module Rubygoal
  class TestFormation < Minitest::Test
    def setup
      @formation = Formation.new
    end

    def test_formation_types
      players = {
        average1: AveragePlayer.new(:home),
        average2: AveragePlayer.new(:home),
        average3: AveragePlayer.new(:home),
        average4: AveragePlayer.new(:home),
        average5: AveragePlayer.new(:home),
        average6: AveragePlayer.new(:home),
        captain: CaptainPlayer.new(:home),
        fast1: FastPlayer.new(:home),
        fast2: FastPlayer.new(:home),
        fast3: FastPlayer.new(:home)
      }
      @formation.lineup = [
        [:average1, :none, :average2, :none,     :none],
        [:fast1,    :none, :none,     :average3, :none],
        [:none,     :none, :captain,  :none,     :fast2],
        [:fast3,    :none, :none,     :none,     :average4],
        [:average5, :none, :average6, :none,     :none],
      ]
      expected = [
        [:average, :none, :average, :none,    :none],
        [:fast,    :none, :none,    :average, :none],
        [:none,    :none, :captain, :none,    :fast],
        [:fast,    :none, :none,    :none,    :average],
        [:average, :none, :average, :none,    :none],
      ]
      assert_equal expected, @formation.formation_types(players).lineup
    end
  end
end
