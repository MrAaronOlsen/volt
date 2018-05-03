module Volt
  module Collision
    module Handlers
      class RectCircle < Base
        attr_reader :contact

        def initialize(rect, circ)
          @rect = @body1 = rect
          @circ = @body2 = circ
        end

        def query
          @center = @circ.world_position(@circ.centroid)
          @radius = @circ.radius

          @verts = @rect.verts.map do |vert|
            @rect.world_position(vert)
          end.sort_by { |vert| vert.distance_to(@center) }

          @line_start = @verts[0]
          @line_end = @verts[1]

          @segment = @line_start - @line_end

          @to_start = @center.distance_to(@line_start)
          @to_end = @center.distance_to(@line_end)

          @thread = @line_start - @center
          @projection = @thread.projection_onto(@segment)
          @contact_loc = @line_start - @projection
          @penetration = @radius - @contact_loc.distance_to(@center)
          @contact_normal = @segment.normal.unit * -1

          circ_rect_collision
        end

        def debug
          Canvas::Pencil.line([@line_start, @line_start - @thread], Canvas::Color.red, 1)
          Canvas::Pencil.line([@line_start, @line_start - @projection], Canvas::Color.blue, 10)
          Canvas::Pencil.line([@contact_loc, @center], Canvas::Color.green, 1)
          Canvas::Pencil.circle(@contact_loc, 10, Canvas::Color.yellow, true, 2)
        end

      private

        def circ_rect_collision
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