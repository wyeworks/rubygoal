require 'test_helper'

module Rubygoal
  class MatchDataTest < Minitest::Test
    def test_home_team_is_winning
      match_data = create_match_data(
        :home,
        score_home: 2,
        score_away: 0
      )

      assert match_data.me.winning?
      assert match_data.other.losing?
    end

    def test_home_team_is_losing
      match_data = create_match_data(
        :home,
        score_home: 1,
        score_away: 3
      )

      assert match_data.me.losing?
      assert match_data.other.winning?
    end

    def test_away_team_is_winning
      match_data = create_match_data(
        :away,
        score_home: 0,
        score_away: 2
      )

      assert match_data.me.winning?
      assert match_data.other.losing?
    end

    def test_away_team_is_losing
      match_data = create_match_data(
        :away,
        score_home: 3,
        score_away: 1
      )

      assert match_data.me.losing?
      assert match_data.other.winning?
    end

    def test_home_team_is_a_draw
      match_data = create_match_data(
        :home,
        score_home: 1,
        score_away: 1
      )

      assert match_data.me.draw?
      assert match_data.other.draw?
    end

    def test_away_team_is_a_draw
      match_data = create_match_data(
        :away,
        score_home: 1,
        score_away: 1
      )

      assert match_data.me.draw?
      assert match_data.other.draw?
    end

    def test_match_info_includes_time
      match_data = create_match_data(
        :away,
        time: 100
      )

      assert_equal 100, match_data.time
    end

    def test_match_info_includes_player_positions
      match_data = create_match_data(
        :away,
        home_players_positions: {
          name: Position.new(Field::WIDTH, Field::HEIGHT)
        },
        away_players_positions: {
          name: Position.new(Field::WIDTH / 2, 0)
        }
      )

      assert_equal({ name: Position.new(50, 0) }, match_data.me.positions)
      assert_equal({ name: Position.new(100, 100) }, match_data.other.positions)
    end

    def test_home_match_info_includes_ball_position
      match_data = create_match_data(
        :home,
        ball_position: Field.absolute_position(
          Position.new(Field::WIDTH / 4, Field::HEIGHT / 2),
          :home
        )
      )

      assert_equal Position.new(25, 50), match_data.ball
    end

    def test_away_match_info_includes_ball_position
      match_data = create_match_data(
        :away,
        ball_position: Field.absolute_position(
          Position.new(Field::WIDTH / 4, Field::HEIGHT / 2),
          :away
        )
      )

      assert_equal Position.new(25, 50), match_data.ball
    end

    private

    def create_match_data(side, game_options)
      MatchData::Factory.new(game_test_double(game_options), side)
        .create
    end

    def game_test_double(game_options)
      OpenStruct.new({
        time: 0,
        score_home: 0,
        score_away: 0,
        ball_position: Field.center_position,
        home_players_positions: {},
        away_players_positions: {}
      }.merge(game_options))
    end
  end
end
