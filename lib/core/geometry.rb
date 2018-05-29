module Volt
  class Geometry

    class << self
      # Find the geometric center of a convex polygon
      def get_centroid(verts)
        size = verts.size
        verts.reduce(V.new) { |sum, vert| sum += vert / verts.size }
      end

      # Returns the distance of a point along a particulat axis
      def distance_along_axis(axis, point)
        axis.dot(point)
      end

      # Returns 1 if b is to the right of a in reference to o
      def determinant(o, a, b)
        d = (a.y - o.y) * (b.x - a.x) - (b.y - a.y) * (a.x - o.x)
        return 0 if d.zero?

        d <=> 0
      end

      # Linear Interpolation
      def lerp(line_start, line_end, alpha)
        line_start * (1 - alpha) + line_end * alpha
      end

      # Convert a degree to a radian
      def radian(degree)
         degree*(Math::PI/180)
      end

      # Brute force Minkowski Difference
      def minkowski_difference(poly1_verts, poly2_verts)
        dif = Array.new

        poly1_verts.each do |vert1|
          dif += poly2_verts.map do |vert2|
            vert1 - vert2
          end
        end
      end

      # Find the closest point from a line
      def closest_point_to_line(points, line_start, line_end)
        closest = nil

        points.each do |point|
          distance = distance_of_point_to_line(point, line_start, line_end)

          if closest.nil? || distance < closest.distance
            closest = PointAlongAxis.new(distance, point)
          end
        end

        return closest
      end

      # Find the closest distance from a point to a line
      def distance_of_point_to_line(point, line_start, line_end)
        segment = line_start - line_end
        d = line_start - point

        projection = d.projection_onto(segment)
        point.distance_to(line_start - projection)
      end

      # Returns true if point is inside of poly.
      def point_is_inside_poly(poly_verts, point)
        count = poly_verts.count
        intersections = 0

        poly_verts.each_with_index do |face_start, i|
          face_end = poly_verts[(i+1) % count]

          if line_line_intersection(V.new(0, 0), point, face_start, face_end)
            intersections += 1
          end
        end

        !intersections.modulo(2).zero?
      end

      # Returns the vector of a line line intersection. Nil if no intersection exists
      def line_line_intersection(l1s, l1e, l2s, l2e)
        seg1 = l1e - l1s
        seg2 = l2e - l2s

        d = (-seg2.x * seg1.y + seg1.x * seg2.y)

        s = (-seg1.y * (l1s.x - l2s.x) + seg1.x * (l1s.y - l2s.y)) / d;
        t = ( seg2.x * (l1s.y - l2s.y) - seg2.y * (l1s.x - l2s.x)) / d;

        if s >= 0 && s <= 1 && t >= 0 && t <= 1
            x = l1s.x + (t * seg1.x)
            y = l1s.y + (t * seg1.y)

            V.new(x, y)
        end
      end

      # Returns the Edge of a poly that intersects a given line. Nil if no intersection exists
      def find_edge_intersecting_with_line(poly_verts, line_start, line_end)
        count = poly_verts.count

        poly_verts.each_with_index do |face_start, i|
          face_end = poly_verts[(i+1) % count]

          contact_loc = line_line_intersection(face_start, face_end, line_start, line_end)

          if contact_loc
            edge = Edge.new(face_start, face_end)
            edge.contact_loc = contact_loc
            return edge
          end
        end

        nil
      end
    end
  end

  Geo = Geometry
end