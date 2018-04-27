module Volt
  module Collision
    module Handlers
      class LineCircle
        attr_reader :contact

        def initialize(line, circ)
          @debug = []
          @line = line
          @circ = circ
        end

        def query
          line_start = @line.world_position(@line.verts[0])
          line_end = @line.world_position(@line.verts[1])
          center = @circ.world_position(@circ.centroid)
          radius = @circ.radius

          @thread = line_start - center

          if circle_point_collide(center, radius, line_start) || circle_point_collide(center, radius, line_end)
            build_contact
          else
            @segment = line_start - line_end
            @projection = @thread.projection_onto(@segment)
            @nearest = line_start + @projection

            if circle_point_collide(center, radius, @nearest) && @projection.mag <= @segment.mag && 0 <= projection.dot(@segment)
              build_contact
            end
          end
        end

        def circle_point_collide(center, radius, point)
          center.distance_to(point) < radius
        end

        def build_contact
        end
      end
    end
  end
end