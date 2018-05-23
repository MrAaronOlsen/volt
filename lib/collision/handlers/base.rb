module Volt
  module Collision
    module Handlers
      class Base

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

          return face
        end

        def find_contact_point_of_line_with_poly(poly_verts, line_start, line_end)
          face = find_face_intersecting_with_line(poly_verts, line_start, line_end)
          face.contact_loc if face.exists?
        end

        def sat_check_for_poly_line(poly_verts, line_vert, line_axis)
          poly_minmax = MinMax.by_projection(poly_verts, line_axis)
          line_minmax = MinMax.by_projection([line_vert], line_axis)

          if poly_minmax.max > line_minmax.min || poly_minmax.min < line_minmax.max
            return [poly_minmax.max - line_minmax.min, poly_minmax.max - line_minmax.min].min
          end
        end

        def sat_check_for_poly_face(poly_verts, face_verts, axis)
          poly_minmax = MinMax.by_projection(poly_verts, axis)
          face_minmax = MinMax.by_projection(face_verts, axis)

          if poly_minmax.max > face_minmax.min && poly_minmax.min < face_minmax.max
            return [poly_minmax.max - face_minmax.min, poly_minmax.max - face_minmax.min].min
          end
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
              closest = Struct.new(:distance, :point).new(distance, point)
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

        def circle_face_or_point_collision
          if @penetration > 0 && @projection.dot(@segment) > 0 && @projection.mag < @segment.mag
            return true
          else
            to_start = @center.distance_to(@line_start)

            if to_start < @radius
              @contact_loc = @line_start
              @penetration = @radius - to_start
              @contact_normal = (@line_start - @center).unit
              return true
            end

            to_end = @center.distance_to(@line_end)

            if to_end < @radius
              @contact_loc = @line_end
              @penetration = @radius - to_end
              @contact_normal = (@line_end - @center).unit
              return true
            end
          end
        end
      end
    end
  end
end