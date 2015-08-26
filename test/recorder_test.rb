require 'test_helper'
require 'timecop'

require 'rubygoal/recorder'

module Rubygoal
  class RecorderTest < Minitest::Test
    def setup
      Rubygoal.configuration.record_game = true

      home_coach = Coach.new(TestHomeCoachDefinition.new)
      away_coach = Coach.new(TestAwayCoachDefinition.new)
      @game = Game.new(home_coach, away_coach)
      @recorder = @game.recorder
    end

    def test_recorded_team_names
      expected_teams = {
        home: 'Test Home Team',
        away: 'Test Away Team'
      }

      assert_equal expected_teams, recorder.to_hash[:teams]
    end

    def test_initial_recorded_frames
      assert_equal [], recorder.to_hash[:frames]
    end

    def test_recorded_frame_after_first_update
      @game.update

      ball_position = Field.center_position
      frames = recorder.to_hash[:frames]

      assert_equal 1, frames.count
      assert_in_delta 120, frames.first[:time], 0.001
      assert_equal(
        { home: 0, away: 0 },
        frames.first[:score]
      )
      assert_equal(
        { x: ball_position.x, y: ball_position.y},
        frames.first[:ball]
      )
    end

    def test_recorded_frame_with_11_values_for_player_positions
      @game.update

      first_frame = recorder.to_hash[:frames].first
      home_player_positions = first_frame[:teams][:home_player_positions]
      away_player_positions = first_frame[:teams][:away_player_positions]

      assert_equal 11, home_player_positions.count
      assert_equal 11, away_player_positions.count
    end

    def test_recorded_frame_with_absolute_player_positions
      @game.update

      first_frame = recorder.to_hash[:frames].first
      home_player_positions = first_frame[:teams][:home_player_positions]
      away_player_positions = first_frame[:teams][:away_player_positions]

      goalkeeper_field_pos = Position.new(50, Field::HEIGHT / 2)
      goalkeeper_pos_home = Field.absolute_position(goalkeeper_field_pos, :home)
      goalkeeper_pos_away = Field.absolute_position(goalkeeper_field_pos, :away)

      assert_equal goalkeeper_pos_home, home_player_positions.first
      assert_equal goalkeeper_pos_away, away_player_positions.first
    end

    def test_recorded_frame_some_updates
      time = Time.now
      21.times do
        @game.update
        time += 0.25
        Timecop.travel(time)
      end

      frames = recorder.to_hash[:frames]

      assert_equal 21, frames.count
      assert_in_delta 120, frames.first[:time], 0.001
      assert_in_delta 115, frames.last[:time], 0.001
    end

    private

    attr_reader :game, :recorder
  end
end
