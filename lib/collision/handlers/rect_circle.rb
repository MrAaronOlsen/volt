module Volt
  module Collision
    module Handlers
      class RectCircle < Base

        def initialize(rect, circ)
          @rect, @circ = rect, circ
        end

        def query
          @center = @circ.world_position(@circ.centroid)
          @radius = @circ.radius

          @verts = @rect.verts.map do |vert|
            @rect.world_position(vert)
          end.sort_by { |vert| vert.distance_to(@center) }

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
          Contact.new(@rect, @circ) do |contact|
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