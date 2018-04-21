module Volt
  class Collision
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
        @collisions << Contact.new(body1, body2)
      end

      def collide?(body1, body2)
        b1 = body1.bounding
        b2 = body2.bounding

        center1 = body1.trans.transform_vert(b1.center)
        radius1 = b1.radius
        center2 = body2.trans.transform_vert(b2.center)
        radius2 = b2.radius

        distance = center1.distance(center2)

        distance - radius1 <= radius2 || distance - radius2 <= radius1
      end
    end
  end
end