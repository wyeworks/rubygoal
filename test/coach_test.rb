require 'test_helper'
require 'fixtures/four_fast_players_coach_definition'
require 'fixtures/less_players_coach_definition'
require 'fixtures/more_players_coach_definition'
require 'fixtures/two_captains_coach_definition'
require 'fixtures/valid_coach_definition'

module Rubygoal
  class CoachTest < Minitest::Test
    def test_valid_players
      coach = Coach.new(ValidCoachDefinition.new)

      assert coach.valid?
      assert_empty coach.errors
    end

    def test_less_players
      coach = Coach.new(LessPlayersCoachDefnition.new)
      expected_error = ['The number of average players is 5']

      refute coach.valid?
      assert_equal expected_error, coach.errors
    end

    def test_more_players
      coach = Coach.new(MorePlayersCoachDefinition.new)
      expected_error = ['The number of average players is 7']

      refute coach.valid?
      assert_equal expected_error, coach.errors
    end

    def test_more_than_one_captain
      coach = Coach.new(TwoCaptainsCoachDefinition.new)
      expected_errors = ['The number of captains is 2']

      refute coach.valid?
      assert_equal expected_errors, coach.errors
    end

    def test_more_than_three_fast
      coach = Coach.new(FourFastPlayersCoachDefinition.new)
      expected_errors = ['The number of fast players is 4']

      refute coach.valid?
      assert_equal expected_errors, coach.errors
    end
  end
end
