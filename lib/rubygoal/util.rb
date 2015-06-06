module Rubygoal
  module Util
    class << self
      def offset_x(angle, distance)
        distance * Math.cos(angle * Math::PI / 180.0)
      end

      def offset_y(angle, distance)
        distance * Math.sin(angle * Math::PI / 180.0)
      end

      def distance(x1, y1, x2, y2)
        Math.hypot(x2 - x1, y2 - y1)
      end

      def angle(x1, y1, x2, y2)
        Math.atan2(y2 - y1, x2 - x1) / Math::PI * 180.0
      end

      def positive_angle(x1, y1, x2, y2)
        angle = self.angle(x1, y1, x2, y2)
        if angle < 0
          360 + angle
        else
          angle
        end
      end

      def y_intercept_with_line(x, pos1, pos2)
        slope = (pos2.y - pos1.y) / (pos2.x - pos1.x)

        Position.new(x, slope * (x - pos1.x) + pos1.y)
      end
    end
  end
end
