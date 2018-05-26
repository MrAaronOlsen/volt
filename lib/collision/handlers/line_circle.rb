module Volt
  module Collision
    class LineCircle < Base

      def initialize(line, circ)
        @line, @circ = line, circ
      end

      def query
        @line_start = Ref.get(@line.body, @line.verts[0])
        @line_end = Ref.get(@line.body, @line.verts[1])

        @center = Ref.get(@circ.body, @circ.centroid)
        @radius = @circ.radius

        @segment = @line_start - @line_end
        thread = @line_start - @center
        @projection = thread.projection_onto(@segment)

        @contact_loc = @line_start - @projection
        @contact_normal = (@contact_loc - @center).unit
        @penetration = @radius - @contact_loc.distance_to(@center)

        circle_face_or_point_collision
      end

      def circle_face_or_point_collision
        if @penetration > 0 && @projection.dot(@segment) > 0 && @projection.mag < @segment.mag
          return true
        else
          to_start = @center.distance_to(@line_start)

          if to_start < @radius
            @contact_loc = @line_start
            @penetration = @radius - to_start
            @contact_normal = (@line_start - @center).unit
            return true
          end

          to_end = @center.distance_to(@line_end)

          if to_end < @radius
            @contact_loc = @line_end
            @penetration = @radius - to_end
            @contact_normal = (@line_end - @center).unit
            return true
          end
        end
      end

      def get_contact
        Contact.new(@line, @circ) do |contact|
          contact.handler = self
          contact.penetration = @penetration
          contact.contact_normal = @contact_normal
          contact.contact_loc = @contact_loc
        end
      end
    end
  end
end