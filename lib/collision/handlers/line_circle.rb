module Volt
  module Collision
    module Handlers
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
end