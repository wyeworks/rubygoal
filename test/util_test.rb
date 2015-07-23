require 'test_helper'

module Rubygoal
  class UtilTest < Minitest::Test
    def test_line_equation_with_45_grades_in_origin
      origin = Position.new(0,0)
      grade = Math::PI / 4

      line = Util.line_equation(origin, grade)

      assert_in_delta 1, line[:a]
      assert_in_delta 0, line[:b]
    end

    def test_line_equation_with_30_grades_in_given_point
      origin = Position.new(2,1)
      grade = Math::PI / 6

      line = Util.line_equation(origin, grade)

      assert_in_delta 0.577, line[:a]
      assert_in_delta 1 - 0.577 * 2, line[:b]
    end

    def test_distance_point_to_line
      point = Position.new(2,1)
      line = { a: 1, b: 0 }

      distance = Util.distance_point_to_line(point, line)

      assert_in_delta Math.sqrt(2) / 2, distance
    end

    def test_distance_point_to_line_within_the_line
      point = Position.new(1,1)
      line = { a: 1, b: 0 }

      distance = Util.distance_point_to_line(point, line)

      assert_in_delta 0, distance
    end

    def test_distance_point_to_line_2
      point = Position.new(0, 5)
      line = { a: 1, b: 1 }

      distance = Util.distance_point_to_line(point, line)

      assert_in_delta Math.sqrt(8), distance
    end
  end
end
