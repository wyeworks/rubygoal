require 'test_helper'

module Rubygoal
  class MatchDataTest < Minitest::Test
    def setup
      @game = Game.new
    end

    def test_home_team_is_winning
      game.send(:score_home=, 3)
      game.send(:score_away=, 1)
      create_home_match_data

      assert match_data.me.winning?
      assert match_data.other.losing?
    end

    def test_home_team_is_losing
      game.send(:score_home=, 1)
      game.send(:score_away=, 3)
      create_home_match_data

      assert match_data.me.losing?
      assert match_data.other.winning?
    end

    def test_away_team_is_winning
      game.send(:score_home=, 0)
      game.send(:score_away=, 2)
      create_away_match_data

      assert match_data.me.winning?
      assert match_data.other.losing?
    end

    def test_away_team_is_losing
      game.send(:score_home=, 3)
      game.send(:score_away=, 1)
      create_away_match_data

      assert match_data.me.losing?
      assert match_data.other.winning?
    end

    def test_home_team_is_a_draw
      game.send(:score_home=, 1)
      game.send(:score_away=, 1)
      create_home_match_data

      assert match_data.me.draw?
      assert match_data.other.draw?
    end

    def test_away_team_is_a_draw
      game.send(:score_home=, 1)
      game.send(:score_away=, 1)
      create_away_match_data

      assert match_data.me.draw?
      assert match_data.other.draw?
    end

    def test_match_info_includes_time
      game.send(:time=, 100)
      create_away_match_data

      assert_equal 100, match_data.time
    end

    def test_match_info_includes_player_positions
      game.team_home.players[:godin].position =
        Field.absolute_position(Position.new(Field::WIDTH, Field::HEIGHT), :home)
      game.team_away.players[:captain].position =
        Field.absolute_position(Position.new(Field::WIDTH / 2, 0), :away)

      create_away_match_data

      assert_equal 10, match_data.me.positions.size
      assert_equal Position.new(50, 0), match_data.me.positions[:captain]
      assert_equal 10, match_data.other.positions.size
      assert_equal Position.new(100, 100), match_data.other.positions[:godin]
    end

    def test_home_match_info_includes_ball_position
      game.ball.position =
        Field.absolute_position(
          Position.new(Field::WIDTH / 4, Field::HEIGHT / 2),
          :home
        )
      create_home_match_data

      assert_equal Position.new(25, 50), match_data.ball
    end

    def test_away_match_info_includes_ball_position
      game.ball.position =
        Field.absolute_position(
          Position.new(Field::WIDTH / 4, Field::HEIGHT / 2),
          :away
        )
      create_away_match_data

      assert_equal Position.new(25, 50), match_data.ball
    end

    private

    attr_accessor :game, :match_data

    def create_home_match_data
      factory = MatchData::HomeFactory.new(game)
      self.match_data = factory.create
    end

    def create_away_match_data
      factory = MatchData::AwayFactory.new(game)
      self.match_data = factory.create
    end
  end
end
