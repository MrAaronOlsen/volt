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
          @line_start = @line.world_position(@line.verts[0])
          @line_end = @line.world_position(@line.verts[1])
          @center = @circ.world_position(@circ.centroid)
          @radius = @circ.radius

          @segment = @line_start - @line_end

          @to_start = @center.distance_to(@line_start)
          @to_end = @center.distance_to(@line_end)

          @thread = @line_start - @center
          @projection = @thread.projection_onto(@segment)

          @contact_loc = @line_start - @projection
          @contact_normal = (@contact_loc - @center).unit
          @penetration = @radius - @contact_loc.distance_to(@center)

          line_circ_collision
        end

        def debug
          Canvas::Pencil.line([@line_start, @line_start - @thread], Canvas::Color.red, 1)
          Canvas::Pencil.line([@line_start, @line_start - @projection], Canvas::Color.blue, 10)
          Canvas::Pencil.line([@contact_loc, @center], Canvas::Color.green, 1)
          Canvas::Pencil.circle(@contact_loc, 10, Canvas::Color.yellow, true, 2)
        end

        private

        def line_circ_collision
          if @to_start < @radius
            @contact_loc = @line_start
            @penetration = @radius - @to_start
            true
          elsif @to_end < @radius
            @contact_loc = @line_end
            @penetration = @radius - @to_end
            true
          elsif @penetration > 0 && @projection.dot(@segment) > 0 && @projection.mag < @segment.mag
            true
          else
            false
          end
        end
      end
    end
  end
end