module Volt
  module Collision
    class LineCircle

      def initialize(line, circ)
        @line, @circ = line, circ
      end

      def query
        line_start = Ref.get(@line.body.trans, @line.verts[0])
        line_end = Ref.get(@line.body.trans, @line.verts[1])

        center = Ref.get(@circ.body.trans, @circ.centroid)
        radius = @circ.radius

        segment = line_start - line_end
        d = line_start - center

        projection = d.projection_onto(segment)
        ref_point = line_start - projection

        @penetration = radius - ref_point.distance_to(center)

        if @penetration > 0 && projection.dot(segment) > 0 && projection.mag < segment.mag
          @contact_normal = (ref_point - center).unit
          @contact_loc = ref_point + (@contact_normal * @penetration)

          return true
        else
          to_start = center.distance_to(line_start)

          if to_start < radius
            @penetration = radius - to_start
            @contact_normal = (line_start - center).unit
            @contact_loc = line_start + (@contact_normal * @penetration)

            return true
          else
            to_end = center.distance_to(line_end)

            if to_end < radius
              @penetration = radius - to_end
              @contact_normal = (line_end - center).unit
              @contact_loc = line_end + (@contact_normal * @penetration)

              return true
            end
          end

          return false
        end
      end

      def get_contact
        Contact.new(@line, @circ) do |contact|
          contact.penetration = @penetration
          contact.contact_normal = @contact_normal
          contact.contact_loc = @contact_loc
        end
      end
    end
  end
end