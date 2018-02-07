module Volt
  class BroadPhase
    class Handler
      attr_reader :collisions

      def query(bodies)
        @collisions = []

        bodies.each_with_index do |body, i|
          query_this(body, bodies[i+1..-1])
        end
      end

      def query_this(body1, bodies)
        bodies.each do |body2|
          add_collision(body1, body2) if collide?(body1, body2)
        end
      end

      def add_collision(body1, body2)
        @collisions << Collision.new(body1, body2)
      end

      def collide?(body1, body2)
        center1 = body1.bounding.world_center
        radius1 = body1.bounding.radius
        center2 = body2.bounding.world_center
        radius2 = body2.bounding.radius

        distance = (center1 - center2).mag

        distance - radius1 <= radius2 || distance - radius2 <= radius1
      end
    end
  end
end