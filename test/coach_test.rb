require 'test_helper'
require 'fixtures/four_fast_players_coach'
require 'fixtures/less_players_coach'
require 'fixtures/more_players_coach'
require 'fixtures/two_captains_coach'
require 'fixtures/valid_coach'

module Rubygoal
  class PlayerTest < Minitest::Test
    def test_valid_players
      coach = ValidCoach.new

      assert coach.valid?
      assert_empty coach.errors
    end

    def test_less_players
      coach = LessPlayersCoach.new
      expected_error = { average: 'The number of average players is 5' }

      refute coach.valid?
      assert_equal expected_error, coach.errors
    end

    def test_more_players
      coach = MorePlayersCoach.new
      expected_error = { average: 'The number of average players is 7' }

      refute coach.valid?
      assert_equal expected_error, coach.errors
    end

    def test_more_than_one_captain
      coach = TwoCaptainsCoach.new
      expected_errors = {
        captain: 'The number of captains is 2',
        average: 'The number of average players is 5'
      }

      refute coach.valid?
      assert_equal expected_errors, coach.errors
    end

    def test_more_than_three_fast
      coach = FourFastPlayersCoach.new
      expected_errors = {fast: 'The number of fast players is 4', average: 'The number of average players is 5'}

      refute coach.valid?
      assert_equal expected_errors, coach.errors
    end
  end
end
