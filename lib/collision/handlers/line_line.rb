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

        return false unless @contact_loc

        l1_point = Geo.closest_point_to_line([line1_start, line1_end], line2_start, line2_end)
        l2_point = Geo.closest_point_to_line([line2_start, line2_end], line1_start, line1_end)

        if l1_point.distance < l2_point.distance
          @penetration = l1_point.distance
          @contact_normal = (line2_start - line2_end).normal.unit
        else
          @penetration = l2_point.distance
          @contact_normal = (line1_start - line1_end).normal.unit
        end

        d = Geo.get_centroid([line1_start, line1_end]) - Geo.get_centroid([line2_start, line2_end])
        @contact_normal.flip if d.dot(@contact_normal) < 0

        return true
      end

      def get_contact
        Contact.new(@line1, @line2) do |contact|
          contact.penetration = @penetration
          contact.contact_normal = @contact_normal
          contact.contact_loc = @contact_loc
        end
      end
    end
  end
end