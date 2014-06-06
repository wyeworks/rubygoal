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
  end
end
