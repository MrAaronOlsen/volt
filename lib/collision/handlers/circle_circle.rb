module Volt
  module Collision
    module Handlers
      class CircleCircle

        def query(shape1, shape2)
          center1 = shape1.world_position(shape1.center)
          radius1 = shape1.radius

          center2 = shape2.world_position(shape2.center)
          radius2 = shape2.radius

          distance = center1.distance_to(center2)

          if distance / 2 <= [radius1, radius2].max
            binding.pry
          end
        end
      end
    end
  end
end