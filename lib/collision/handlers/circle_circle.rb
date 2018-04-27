module Volt
  module Collision
    module Handlers
      class CircleCircle
        attr_reader :contact

        def query(shape1, shape2, contact)
          center1 = shape1.world_position(shape1.centroid)
          radius1 = shape1.radius

          center2 = shape2.world_position(shape2.centroid)
          radius2 = shape2.radius

          penetration = (radius1 + radius2) - center1.distance_to(center2)
          midline = center1 - center2

          if penetration > 0
            @contact = Contact.new(shape1.body, shape2.body)

            @contact.penetration = penetration
            @contact.contact_normal = midline.unit
            @contact.contact_loc = center1 + (midline * 0.5)
            @contact.restitution = 1.0

            @contact.add_shapes(shape1, shape2)
          end
        end
      end
    end
  end
end