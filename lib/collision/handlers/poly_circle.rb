module Volt
  module Collision
    module Handlers
      class PolyCircle < Base

        def initialize(poly, circ)
          @poly, @circ = poly, circ
        end

        def query
          @center = Ref.get(@circ.body, @circ.centroid)
          @radius = @circ.radius

          @verts = Ref.get_all(@poly.body, @poly.verts)
          @verts = @verts.sort_by { |vert| vert.distance_to(@center) }

          @line_start = @verts[0]
          @line_end = @verts[1]

          @segment = @line_start - @line_end
          @thread = @line_start - @center
          @projection = @thread.projection_onto(@segment)

          @contact_loc = @line_start - @projection
          @contact_normal = (@contact_loc - @center).unit
          @penetration = @radius - @contact_loc.distance_to(@center)

          circle_face_or_point_collision
        end

        def get_contact
          Contact.new(@poly, @circ) do |contact|
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