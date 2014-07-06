require 'test_helper'

require 'rubygoal/formation'

module Rubygoal
  class TestFormation < Minitest::Test
    def setup
      @formation = Formation.new
    end

    def test_valid_formation
      @formation.lineup = [
        [:average, :none, :average, :none,    :none],
        [:fast,    :none, :none,    :average, :none],
        [:none,    :none, :captain, :none,    :fast],
        [:fast,    :none, :none,    :none, :average],
        [:average, :none, :average, :none,    :none],
      ]
      assert @formation.valid?
    end

    def test_less_players
      @formation.lineup = [
        [:average, :none, :average, :none, :none],
        [:fast,    :none, :none,    :none, :none],
        [:none,    :none, :captain, :none, :fast],
        [:fast,    :none, :none,    :none, :average],
        [:average, :none, :average, :none, :none],
      ]
      assert !@formation.valid?
    end

    def test_more_players
      @formation.lineup = [
        [:average, :none, :average, :none,    :average],
        [:fast,    :none, :none,    :average, :none],
        [:none,    :none, :captain, :none,    :fast],
        [:fast,    :none, :none,    :none,    :average],
        [:average, :none, :average, :none,    :none],
      ]
      assert !@formation.valid?
    end

    def test_more_than_one_captain
      @formation.lineup = [
        [:average, :none, :average, :none,    :none],
        [:fast,    :none, :none,    :captain, :none],
        [:none,    :none, :captain, :none,    :fast],
        [:fast,    :none, :none,    :none, :average],
        [:average, :none, :average, :none,    :none],
      ]
      assert !@formation.valid?
    end

    def test_more_than_three_fast
      @formation.lineup = [
        [:average, :none, :average, :none, :none],
        [:fast,    :none, :none,    :fast, :none],
        [:none,    :none, :captain, :none, :fast],
        [:fast,    :none, :none,    :none, :average],
        [:average, :none, :average, :none, :none],
      ]
      assert !@formation.valid?
    end

    def test_new_valid_formation
      @formation.lineup = [
        [:average1, :none, :average2, :none,    :none],
        [:fast1,    :none, :none,    :average3, :none],
        [:none,    :none, :captain, :none,    :fast2],
        [:fast3,    :none, :none,    :none, :average4],
        [:average5, :none, :average6, :none,    :none],
      ]
      assert @formation.valid?
    end

    def test_new_old_formation_mixed_invalid
      @formation.lineup = [
        [:average1, :none, :average2, :none,    :none],
        [:fast1,    :none, :none,    :average3, :none],
        [:none,    :none, :captain, :none,    :fast2],
        [:fast,    :none, :none,    :none, :average4],
        [:average5, :none, :average, :none,    :none],
      ]
      assert !@formation.valid?
    end

    def test_more_than_six_avg_new_formation
      @formation.lineup = [
        [:average1, :none, :average2, :none,    :average3],
        [:fast1,    :none, :none,    :average4, :none],
        [:none,    :none, :captain, :none,    :fast2],
        [:fast2,    :none, :none,    :none,    :average5],
        [:average6, :none, :average6, :none,    :none],
      ]
      assert !@formation.valid?
    end

    def test_more_than_three_fast_new_formation
      @formation.lineup = [
        [:average1, :none, :average2, :none, :none],
        [:fast1,    :none, :none,    :fast2, :none],
        [:none,    :none, :captain, :none, :fast3],
        [:fast4,    :none, :none,    :none, :average5],
        [:average3, :none, :average4, :none, :none],
      ]
      assert !@formation.valid?
    end
  end
end
