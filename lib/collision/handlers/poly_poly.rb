module Volt
  module Collision
    module Handlers
      class PolyPoly < Base
        attr_reader :type

        def initialize(poly1, poly2)
          @poly1, @poly2 = poly1, poly2
        end

        def query
          @poly1_verts = Ref.get_all(@poly1.body, @poly1.verts)
          @poly2_verts = Ref.get_all(@poly2.body, @poly2.verts)

          poly1_count = @poly1_verts.count
          poly2_count = @poly2_verts.count

          @poly1_verts.each_with_index do |p1_start, i|
            p1_end = @poly1_verts[(i+1) % poly1_count]

            @poly2_verts.each_with_index do |p2_end, i|
              p2_start = @poly2_verts[(i+1) % poly2_count]

              @contact_loc = line_line_intersection(p1_start, p1_end, p2_start, p2_end)

              if @contact_loc
                collide(p1_start, p1_end, p2_start, p2_end)
                return true
              end
            end
          end

          false
        end

        def collide(line_start, line_end, side_start, side_end)
          line_seg = line_end - line_start
          side_seg = side_end - side_start

          closest_line = closest_point_to_line([line_start, line_end], side_start, side_end)
          closest_side = closest_point_to_line([side_start, side_end], line_start, line_end)

          if closest_line.distance < closest_side.distance
            # Line has collided with a box side
            @penetration = closest_line.distance
            @contact_normal = side_seg.normal.unit
          else
            # Box corner has collided with the line
            @penetration = closest_side.distance
            @contact_normal = line_seg.normal.unit
          end
        end

        def get_contact
          Contact.new(@poly1, @poly2) do |contact|
            contact.handler = self
            contact.penetration = @penetration
            contact.contact_normal = @contact_normal
            contact.contact_loc = @contact_loc
          end
        end
      end
    end
  end
end