module Volt
  module Collision
    module Handlers
      class PolyLine < Base
        attr_reader :type

        def initialize(poly, line)
          @poly, @line = poly, line
        end

        def query
          @line_start = Ref.get(@line.body, @line.verts[0])
          @line_end = Ref.get(@line.body, @line.verts[1])

          @poly_verts = Ref.get_all(@poly.body, @poly.verts)
          @poly_center = Ref.get(@poly.body, @poly.centroid)

          @poly_verts.each_with_index do |vert1, i|
            vert2 = @poly_verts[(i+1) % @poly_verts.count]
            @contact_loc = line_line_intersection(@line_start, @line_end, vert1, vert2)

            if @contact_loc
              collide(@line_start, @line_end, vert1, vert2)
              return true
            end
          end

          false
        end

        def get_contact
          Contact.new(@poly, @line) do |contact|
            contact.handler = self
            contact.penetration = @penetration
            contact.contact_normal = @contact_normal
            contact.contact_loc = @contact_loc
          end
        end

      private

        def collide(line_start, line_end, side_start, side_end)
          line_seg = line_end - line_start
          side_seg = side_end - side_start

          closest_line = closest_point_to_line([line_start, line_end], side_start, side_end)
          closest_side = closest_point_to_line([side_start, side_end], line_start, line_end)

          if closest_line.distance < closest_side.distance
            # Line has collided with a box side
            @penetration = closest_line.distance
            @line_center = line_start + (line_seg * 0.5)

            @contact_normal = side_seg.normal.unit
          else
            # Box corner has collided with the line
            @penetration = closest_side.distance
            @line_center = side_start + (side_seg * 0.5)

            @face_start, @face_end = line_start, line_end
            d = determinant(line_start, line_end, closest_side.point)
            @contact_normal = line_seg.normal.unit * d
          end
        end
      end
    end
  end
end