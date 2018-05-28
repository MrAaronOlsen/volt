module Volt
  module Collision
    class LineLine

      def initialize(line1, line2)
        @line1, @line2 = line1, line2
      end

      def query
        line1_start = Ref.get(@line1.body.trans, @line1.verts[0])
        line1_end = Ref.get(@line1.body.trans, @line1.verts[1])

        line2_start = Ref.get(@line2.body.trans, @line2.verts[0])
        line2_end = Ref.get(@line2.body.trans, @line2.verts[1])

        @contact_loc = Geo.line_line_intersection(line1_start, line1_end, line2_start, line2_end)

        if @contact_loc
          seg1 = line1_start - line1_end
          seg2 = line2_start - line2_end

          l1_point = Geo.closest_point_to_line([line1_start, line1_end], line2_start, line2_end)
          l2_point = Geo.closest_point_to_line([line2_start, line2_end], line1_start, line1_end)

          if l1_point.distance < l2_point.distance
            @penetration = l1_point.distance

            d = Geo.determinant(line2_start, line2_end, l1_point.point)
            @contact_normal = seg2.normal.unit * d
          else
            @penetration = l2_point.distance

            d = Geo.determinant(line1_start, line1_end, l2_point.point)
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
    end
  end
end