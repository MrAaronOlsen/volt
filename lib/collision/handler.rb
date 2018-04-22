module Volt
  class Collision
    class Handler
      attr_reader :contacts

      def query(bodies)
        @contacts = []

        bodies.each_with_index do |body, i|
          query_broad(body, bodies[i+1..-1])
        end
      end

      def query_broad(body1, bodies)
        bodies.each do |body2|
          @contacts << Contact.new(body1, body2) if broad_collide?(body1, body2)
        end
      end

      def broad_collide?(body1, body2)
        b1 = body1.bounding
        b2 = body2.bounding

        center1 = body1.trans.transform_vert(b1.center)
        radius1 = b1.radius
        center2 = body2.trans.transform_vert(b2.center)
        radius2 = b2.radius

        distance = center1.distance(center2)

        distance - radius1 <= radius2 || distance - radius2 <= radius1
      end

      def narrow_collide?

      end
    end
  end
end