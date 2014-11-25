module Rubygoal
  module Util
    def self.offset_x(angle, distance)
      distance * Math.cos(angle * Math::PI / 180.0)
    end

    def self.offset_y(angle, distance)
      distance * Math.sin(angle * Math::PI / 180.0)
    end

    def self.distance(x1, y1, x2, y2)
      Math.hypot(x2 - x1, y2 - y1)
    end

    def self.angle(x1, y1, x2, y2)
      Math.atan2(y2 - y1, x2 - x1) / Math::PI * 180.0
    end
  end
end
