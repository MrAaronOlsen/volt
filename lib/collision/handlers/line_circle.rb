module Volt
  module Collision
    module Handlers
      class LineCircle < Base
        attr_reader :contact

        def initialize(line, circ)
          @line = @body1 = line
          @circ = @body2 = circ
        end

        def query
          line_start = @line.world_position(@line.verts[0])
          line_end = @line.world_position(@line.verts[1])
          center = @circ.world_position(@circ.centroid)
          radius = @circ.radius

          segment = line_start - line_end

          thread = line_start - center
          projection = thread.projection_onto(segment)

          contact_loc = line_start - projection
          contact_normal = (contact_loc - center).unit
          @penetration = radius - contact_loc.distance_to(center)

          if @penetration > 0 && projection.dot(segment) > 0 && projection.mag < segment.mag
            @contact_normal = contact_normal
            @contact_loc = contact_loc
            return true
          else
            to_start = center.distance_to(line_start)
            to_end = center.distance_to(line_end)

            if to_start < radius
              @contact_loc = line_start
              @penetration = radius - to_start
              @contact_normal = (line_start - center).unit
              return true
            end

            if to_end < radius
              @contact_loc = line_end
              @penetration = radius - to_end
              @contact_normal = (line_end - center).unit
              return true
            end
          end

          false
        end

        def debug
          Canvas::Pencil.circle(@contact_loc, 10, Canvas::Color.yellow, true, 2)
        end
      end
    end
  end
end