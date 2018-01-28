module Volt
  class BroadPhase
    class Bounding
      attr_reader :hull, :b_circle

      def initialize(hull)
        @hull = hull

        make_circle(@hull.verts)
      end

      def make_circle(verts)
        points = Array.new(verts)

        points.each_with_index do |point_a, i|
          if @b_circle.nil? || !@b_circle.contains_point(point_a)
            @b_circle = make_circle_one_point(points[0, i], point_a)
          end
        end
      end

      def make_circle_one_point(points, point_a)
        circle = BCircle.new(point_a, 0)

        points.each_with_index do |point_b, i|
          if !circle.contains_point(point_b)
            if circle.radius.zero?
              circle = make_a_diameter(point_a, point_b)
            else
              circle = make_circle_two_points(points[0, i], point_a, point_b)
            end
          end
        end

        circle
      end

      def make_circle_two_points(points, point_a, point_b)
        circle = make_a_diameter(point_a, point_b)
        left, right = nil, nil

        pq = point_b - point_a

        points.each do |point|
          next if circle.contains_point(point)

          cross = pq.cross(point - point_a)
          c = make_a_circumcircle(point_a, point_b, point)

          next if c.nil?

          if (cross > 0 && (left == nil || pq.cross(c.center - point) > pq.cross(left.center - point)))
            left = c
          end

          if (cross < 0 && (right == nil || pq.cross(c.center - point) < pq.cross(right.center - point)))
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
			    return left.radius <= right.radius ? left : right;
        end
      end

      def make_a_diameter(point_a, point_b)
        center = (point_a + point_b) / 2
        radius = [center.distance(point_a), center.distance(point_b)].max

        BCircle.new(center, radius)
      end

      def make_a_circumcircle(a, b, c)
        ox = ([[a.x, b.x].max, c.x].max + [[a.x, b.x].max, c.x].max) / 2
        oy = ([[a.y, b.y].max, c.y].max + [[a.y, b.y].max, c.y].max) / 2

        ax = a.x - ox
        ay = a.y - oy

        bx = b.x - ox
        by = b.y - oy

        cx = c.x - ox
        cy = c.y - oy

        d = (ax * (by - cy) + bx * (cy - ay) + cx * (ay - by)) * 2;

        return nil if d.zero?

    		x = ((ax * ax + ay * ay) * (by - cy) + (bx * bx + by * by) * (cy - ay) + (cx * cx + cy * cy) * (ay - by)) / d;
    		y = ((ax * ax + ay * ay) * (cx - bx) + (bx * bx + by * by) * (ax - cx) + (cx * cx + cy * cy) * (bx - ax)) / d;

        center = V.new(ox + x, oy + y);
    		radius = [[center.distance(a), center.distance(b)].max, center.distance(c)].max

        BCircle.new(center, radius);
      end
    end

    class BCircle
      attr_reader :center, :radius
      attr_reader :epsilon

      def initialize(center, radius)
        @center, @radius = center, radius
        @epsilon = 1 + 1e-14
      end

      def contains_point(point)
        (@center - point).mag <= @radius * epsilon
      end

      def contains_points(points)
        points.all do |point|
          contains_point(point)
        end
      end
    end
  end
end