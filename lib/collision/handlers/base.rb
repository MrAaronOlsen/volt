module Volt
  module Collision
    module Handlers
      class Base

        def distance_of_point_to_line(point, ls, le)
          segment = ls - le
          thread = ls - point

          projection = thread.projection_onto(segment)
          point.distance_to(ls - projection)
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