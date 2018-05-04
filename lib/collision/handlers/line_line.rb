module Volt
  module Collision
    module Handlers
      class LineLine < Base
        attr_reader :contact

        def initialize(line1, line2)
          @line1 = @body1 = line1
          @line2 = @body2 = line2
        end

        def query
          @line1_start = @line1.world_position(@line1.verts[0])
          @line1_end = @line1.world_position(@line1.verts[1])

          @line2_start = @line2.world_position(@line2.verts[0])
          @line2_end = @line2.world_position(@line2.verts[1])

          @segment1 = @line1_start - @line1_end
          @segment2 = @line2_start - @line2_end

          @contact_loc = line_line_intersection(@line1_start, @line1_end, @line2_start, @line2_end)

          if @contact_loc
            line1_points = [@line1_start, @line1_end].map do |point|
              distance_of_point_to_line(point, @line2_start, @line2_end)
            end

            line2_points = [@line2_start, @line2_end].map do |point|
              distance_of_point_to_line(point, @line1_start, @line1_end)
            end

            line1_point = line1_points.min_by { |point| point.distance }
            line2_point = line2_points.min_by { |point| point.distance }

            if line1_point.distance < line2_point.distance
              @penetration = line1_point.distance
              center = @line1_start - (@segment1 * 0.5)

              d = determinant(@line2_start, @line2_end, center)
              @contact_normal = @segment2.normal.unit * d
            else
              @penetration = line2_point.distance
              center = @line2_start - (@segment2 * 0.5)

              d = determinant(@line1_start, @line1_end, center)
              @contact_normal = @segment1.normal.unit * d
            end
          end
        end

        def debug
          Canvas::Pencil.circle(@contact_loc, 10, Canvas::Color.yellow, true, 2)
        end
      end
    end
  end
end