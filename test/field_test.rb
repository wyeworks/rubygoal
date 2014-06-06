require 'test_helper'

require 'rubygoal/field'

module Rubygoal
  class FieldTest < Minitest::Test
    def test_center_position
      assert_equal Position.new(959, 581), Field.center_position
    end

    def test_home_goal_position
      assert_equal Position.new(262, 581), Field.goal_position(:home)
    end

    def test_away_goal_position
      assert_equal Position.new(1656, 581), Field.goal_position(:away)
    end

    def test_home_position_side
      assert_equal :home, Field.position_side(Position.new(958, 0))
    end

    def test_away_position_side
      assert_equal :away, Field.position_side(Position.new(960, 0))
    end

    def test_left_out_of_bounds_width
      assert Field.out_of_bounds_width?(Position.new(261, 0))
    end

    def test_inside_left_bounds_width
      assert !Field.out_of_bounds_width?(Position.new(262, 0))
    end

    def test_inside_right_bounds_width
      assert !Field.out_of_bounds_width?(Position.new(1656, 0))
    end

    def test_right_out_of_bounds_width
      assert Field.out_of_bounds_width?(Position.new(1657, 0))
    end

    def test_up_out_of_bounds_height
      assert Field.out_of_bounds_height?(Position.new(0, 111))
    end

    def test_inside_upper_bounds_height
      assert !Field.out_of_bounds_height?(Position.new(0, 112))
    end

    def test_inside_bottom_bounds_height
      assert !Field.out_of_bounds_height?(Position.new(0, 1050))
    end

    def test_down_out_of_bounds_width
      assert Field.out_of_bounds_height?(Position.new(0, 1051))
    end

    def test_middle_goal
      assert Field.goal?(Position.new(261, 581))
    end

    def test_upper_goal
      assert Field.goal?(Position.new(261, 718))
    end

    def test_bottom_goal
      assert Field.goal?(Position.new(261, 444))
    end

    def test_upper_missed_goal
      assert !Field.goal?(Position.new(261, 719))
    end

    def test_bottom_missed_goal
      assert !Field.goal?(Position.new(261, 443))
    end

    def test_close_to_goal_straight
      assert Field.close_to_goal?(Position.new(536, 581), :home)
    end

    def test_not_close_to_goal_straight
      assert !Field.close_to_goal?(Position.new(537, 581), :home)
    end

    def test_close_to_goal_upper_diagonal
      assert Field.close_to_goal?(Position.new(456, 775), :home)
    end

    def test_not_close_to_goal_upper_diagonal
      assert !Field.close_to_goal?(Position.new(457, 776), :home)
    end

    def test_close_to_goal_lower_diagonal
      assert Field.close_to_goal?(Position.new(456, 387), :home)
    end

    def test_not_close_to_goal_lower_diagonal
      assert !Field.close_to_goal?(Position.new(457, 386), :home)
    end
  end
end
