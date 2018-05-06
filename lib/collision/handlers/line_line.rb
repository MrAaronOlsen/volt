module Volt
  module Collision
    module Handlers
      class LineLine < Base

        def initialize(line1, line2)
          @line1, @line2 = line1, line2
        end

        def query
          line1_start = @line1.world_position(@line1.verts[0])
          line1_end = @line1.world_position(@line1.verts[1])

          line2_start = @line2.world_position(@line2.verts[0])
          line2_end = @line2.world_position(@line2.verts[1])

          @contact_loc = line_line_intersection(line1_start, line1_end, line2_start, line2_end)

          if @contact_loc
            seg1 = line1_start - line1_end
            seg2 = line2_start - line2_end

            l1_distance = [line1_start, line1_end].map do |point|
              distance_of_point_to_line(point, line2_start, line2_end)
            end.min

            l2_distance = [line2_start, line2_end].map do |point|
              distance_of_point_to_line(point, line1_start, line1_end)
            end.min

            if l1_distance < l2_distance
              @penetration = l1_distance
              @line_center = line1_start - (seg1 * 0.5)

              d = determinant(line2_start, line2_end, @line_center)
              @contact_normal = seg2.normal.unit * d
            else
              @penetration = l2_distance
              @line_center = line2_start - (seg2 * 0.5)

              d = determinant(line1_start, line1_end, @line_center)
              @contact_normal = seg1.normal.unit * d
            end
          end
        end

        def get_contact
          Contact.new(@line1, @line2) do |contact|
            contact.handler = self
            contact.penetration = @penetration
            contact.contact_normal = @contact_normal
            contact.contact_loc = @contact_loc
          end
        end

        def debug
          Canvas::Pencil.circle(@contact_loc, 10, Canvas::Color.yellow, true, 2)
        end
      end
    end
  end
end