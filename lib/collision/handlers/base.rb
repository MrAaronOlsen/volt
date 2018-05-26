module Volt
  module Collision
    class Base
      include Structs
      include Geometry

      # Returns true if point is inside of poly. Does so using a ray cast.
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

      # Will return the face of a poly intersects a line or nil if not intersections exist
      def find_face_intersecting_with_line(poly_verts, line_start, line_end)
        count = poly_verts.count
        face = nil

        poly_verts.each_with_index do |face_start, i|
          face_end = poly_verts[(i+1) % count]

          contact_loc = line_line_intersection(face_start, face_end, line_start, line_end)

          if contact_loc
            face = Face.new(face_start, face_end)
            face.contact_loc = contact_loc
            break
          end
        end

        face
      end

      def distance_of_point_to_line(point, ls, le)
        segment = ls - le
        thread = ls - point

        projection = thread.projection_onto(segment)
        point.distance_to(ls - projection)
      end

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

      def find_contact_faces(poly1_verts, poly2_verts, axis)
        points1 = Array.new
        points2 = Array.new

        poly1_verts.each do |vert|
          points1 << PointAlongAxis.new(distance_along_axis(axis, vert), vert)
        end

        poly2_verts.each do |vert|
          points2 << PointAlongAxis.new(distance_along_axis(axis, vert), vert)
        end

        farthest = points1.max_by(2) { |point| point.distance.abs }
        closest = points2.min_by(2) { |point| point.distance.abs }

        face1 = Face.new(farthest[0].point, farthest[1].point)
        face2 = Face.new(closest[0].point, closest[1].point)

        if face1.axis.dot(axis) < face2.axis.dot(axis)
          return ContactFaces.new(face1, face2)
        else
          return ContactFaces.new(face2, face1)
        end
      end
    end
  end
end