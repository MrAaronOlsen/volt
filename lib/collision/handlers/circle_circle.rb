module Volt
  module Collision
    module Handlers
      class CircleCircle
        attr_reader :contact

        def initialize(circ1, circ2)
          @circ1 = circ1
          @circ2 = circ2
        end

        def query
          center1 = @circ1.world_position(@circ1.centroid)
          radius1 = @circ1.radius

          center2 = @circ2.world_position(@circ2.centroid)
          radius2 = @circ2.radius

          penetration = (radius1 + radius2) - center1.distance_to(center2)
          midline = center1 - center2

          if penetration > 0
            @contact = Contact.new(@circ1.body, @circ2.body)
            @contact.add_shapes(@circ1, @circ2)
            @contact.handler = self

            @contact.penetration = penetration
            @contact.contact_normal = midline.unit
            @contact.contact_loc = center1 + (midline * 0.5)
            @contact.restitution = 1.0
          end
        end

        def debug

        end
      end
    end
  end
end