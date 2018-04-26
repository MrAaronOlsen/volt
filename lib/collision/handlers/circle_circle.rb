module Volt
  module Collision
    module Handlers
      class CircleCircle

        def query(shape1, shape2, contact)
          center1 = shape1.world_position(shape1.center)
          radius1 = shape1.radius

          center2 = shape2.world_position(shape2.center)
          radius2 = shape2.radius

          distance = center1.distance_to(center2)
          penetration = (radius1 + radius2) - distance

          if penetration > 0
            contact_normal = (center1 - center2).normalize
            contact_loc = shape1.world_position(contact_normal * -radius1)

            contact.penetration = penetration
            contact.contact_normal = contact_normal
            contact.contact_loc = contact_loc
          end
        end
      end
    end
  end
end