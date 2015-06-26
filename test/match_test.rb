require 'test_helper'

module Rubygoal
  class MatchTest < Minitest::Test

    def test_home_team_is_winning
      match = Match.create_for(:home, 100, 2, 0, Position.new(0, 0), {}, {})

      assert match.me.winning?
      assert match.other.losing?
    end

    def test_home_team_is_losing
      match = Match.create_for(:home, 100, 1, 3, Position.new(0, 0), {}, {})

      assert match.me.losing?
      assert match.other.winning?
    end

    def test_away_team_is_winning
      match = Match.create_for(:away, 100, 0, 2, Position.new(0, 0), {}, {})

      assert match.me.winning?
      assert match.other.losing?
    end

    def test_away_team_is_losing
      match = Match.create_for(:away, 100, 3, 1, Position.new(0, 0), {}, {})

      assert match.me.losing?
      assert match.other.winning?
    end

    def test_home_team_is_a_draw
      match = Match.create_for(:home, 100, 1, 1, Position.new(0, 0), {}, {})

      assert match.me.draw?
      assert match.other.draw?
    end

    def test_away_team_is_a_draw
      match = Match.create_for(:away, 100, 1, 1, Position.new(0, 0), {}, {})

      assert match.me.draw?
      assert match.other.draw?
    end

    def test_match_info_includes_time
      match = Match.create_for(:away, 100, 1, 1, Position.new(0, 0), {}, {})

      assert_equal 100, match.time
    end

    def test_match_info_includes_player_positions
      home_pos = { name: Position.new(Field::WIDTH, Field::HEIGHT) }
      away_pos = { name: Position.new(Field::WIDTH / 2, 0) }

      match = Match.create_for(:away, 100, 1, 1, Position.new(0, 0), home_pos, away_pos)

      assert_equal({ name: Position.new(50, 0) }, match.me.positions)
      assert_equal({ name: Position.new(100, 100) }, match.other.positions)
    end

    def test_match_info_includes_ball_position
      ball_pos = Position.new(Field::WIDTH / 2, Field::HEIGHT / 4)

      match = Match.create_for(:away, 100, 1, 1, ball_pos, {}, {})

      assert_equal Position.new(50, 25), match.ball
    end
  end
end
