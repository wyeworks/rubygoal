require 'rubygoal/util'

module Rubygoal
  class Coordinate < Struct.new(:x, :y)
    def distance(coordinate)
      Util.distance(x, y, coordinate.x, coordinate.y)
    end

    def add(coordinate)
      self.class.new(x + coordinate.x, y + coordinate.y)
    end

    def mult(coeficient)
      self.class.new(x * coeficient, y * coeficient)
    end

    def to_s
      "(#{x}, #{y})"
    end
  end

  class Position < Coordinate; end

  class Velocity < Coordinate
    def nonzero?
      x != 0 && y != 0
    end
  end
end
