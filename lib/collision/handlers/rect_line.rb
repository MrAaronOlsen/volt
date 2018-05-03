module Volt
  module Collision
    module Handlers
      class RectLine < Base
        attr_reader :contact

        def initialize(rect, line)
          @rect = @body1 = rect
          @line = @body2 = line
        end

        def query
          @line_start = @line.world_position(@line.verts[0])
          @line_end = @line.world_position(@line.verts[1])
          @rect_verts = @rect.verts.map { |vert| @rect.world_position(vert) }
          @rect_center = @rect.world_position(@rect.centroid)

          rect_line_collision || line_end_collision
        end

        def debug
          Canvas::Pencil.circle(@contact_loc, 10, Canvas::Color.yellow, true, 2)
        end

      private

        def line_end_collision
          @rect_verts.each_with_index do |vert, i|
            vert2 = @rect_verts[(i+1) % @rect_verts.count]
            @contact_loc = seg_seg_intersection(@line_start, @line_end, vert, vert2)

            if @contact_loc
              @penetration = [@contact_loc.distance_to(@line_start), @contact_loc.distance_to(@line_end)].min
              @contact_normal = (vert2 - vert).normal.unit
              return true
            end
          end

          false
        end

        def rect_line_collision
          @base = determinant(@line_start, @line_end, @rect_center)
          @segment = @line_start - @line_end

          @rect_verts.each do |vert|
            determinant = determinant(@line_start, @line_end, vert)

            if determinant != @base
              @thread = @line_start - vert
              @projection = @thread.projection_onto(@segment)

              if @projection.dot(@segment) > 0 && @projection.mag < @segment.mag
                @contact_vert = vert
                @contact_loc = @line_start - @projection
                @penetration = @contact_loc.distance_to(@line_start - @thread)
                @contact_normal = (@segment.normal.unit * determinant) * -1
                return true
              end
            end
          end

          false
        end

      end
    end
  end
end