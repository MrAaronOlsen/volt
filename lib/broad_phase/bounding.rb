module Volt
  class BroadPhase
    class Bounding
      attr_reader :circle, :tab, :color

      def initialize(verts)
        return if verts.count.zero?

        @circle = build_bounding(verts)
      end

      def build_bounding(points)
        circle = solve_simple(points)
        return circle unless circle.nil?

        points.each_with_index do |point_a, i|
          if circle.nil? || !circle.contains_point(point_a)
            circle = circle_one_point(points[0, i], point_a)
          end
        end

        circle
      end

      def circle_one_point(points, point_a)
        circle = Circle.new(point_a, 0)

        points.each_with_index do |point_b, i|
          if circle.contains_point(point_b)
            next
          end

          if circle.radius.zero?
            circle = diameter(point_a, point_b)
          else
            circle = circle_two_points(points[0, i], point_a, point_b)
          end

          display
        end

        circle
      end

      def circle_two_points(points, point_a, point_b)
        circle = diameter(point_a, point_b)
        left, right = nil, nil

        pq = point_b - point_a

        points.each do |point_c|
          if circle.contains_point(point_c)
            next
          end

          cross = pq.cross(point_c - point_a)
          c = circumcircle(point_a, point_b, point_c)

          if c.nil?
            next
          end

          if (cross > 0 && (left == nil || pq.cross(c.center - point_c) > pq.cross(left.center - point_c)))
            left = c
          end

          if (cross < 0 && (right == nil || pq.cross(c.center - point_c) < pq.cross(right.center - point_c)))
            right = c
          end
        end

        if (left == nil && right == nil)
          return circle
        elsif (left == nil)
          return right
        elsif (right == nil)
          return left
        else
          if left.radius <= right.radius
            return left
          else
            return right
          end
        end
      end

      def diameter(a, b)
        center = (a + b) / 2
        radius = [center.distance(a), center.distance(b)].max

        Circle.new(center, radius)
      end

      def circumcircle(a, b, c)
        ox = [a.x, b.x, c.x].min
        oy = [a.y, b.y, c.y].min

        ax, ay = a.x - ox, a.y - oy
        bx, by = b.x - ox, b.y - oy
        cx, cy = c.x - ox, c.y - oy

        d = 1 / ((ax * (by - cy) + bx * (cy - ay) + cx * (ay - by)) * 2)

        return nil if d.zero?

        a2 = ax * ax + ay * ay
        b2 = bx * bx + by * by
        c2 = cx * cx + cy * cy

        x = (a2 * (by - cy) + b2 * (cy - ay) + c2 * (ay - by)) * d;
        y = (a2 * (cx - bx) + b2 * (ax - cx) + c2 * (bx - ax)) * d;

        center = V.new(ox + x, oy + y);
        radius = center.distance(a)

        Circle.new(center, radius);
      end

      def solve_simple(points)
        case points.count
        when 1
          Circle.new(points[0], 0)
        when 2
          diameter(points[0], points[1])
        when 3
          circumcircle(points[0], points[1], points[2])
        else
          nil
        end
      end

      def center
        @circle.center
      end

      def radius
        @circle.radius
      end

      def to_s
        @circle.to_s
      end
    end

    class Circle
      attr_reader :center, :radius
      attr_reader :epsilon

      def initialize(center, radius)
        @center, @radius = center, radius
        @epsilon = 1 + 1e-14
      end

      def contains_points(points)
        points.all do |point|
          contains_point(point)
        end
      end

      def contains_point(point)
        @center.distance(point) <= @radius * epsilon
      end

      def to_s
        "Center: #{@center}, Radius: #{@radius}"
      end
    end
  end
end