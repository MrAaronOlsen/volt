module Volt
  module Collision
    class Contact
      attr_reader :manifold, :body1, :body2
      attr_accessor :dummy

      def initialize(manifold)
        @manifold = manifold
        @dummy = false

        yield self if block_given?
      end

      def add_bodies(body1, body2)
        @body1, @body2 = body1, body2
      end

      def contact_loc
        @manifold.contact_loc
      end

      def contact_normal
        @manifold.contact_normal
      end

      def penetration
        @manifold.penetration
      end

      def restitution
        @manifold.restitution
      end

      def is_joint
        @manifold.is_joint
      end

      def resolve(dt)
        [@body1, @body2].each { |body| body.run_callbacks(:pre, self) }
        return if @dummy

        Impulse.resolve_interpenetration(self, dt)
        Impulse.resolve_velocity(self, dt)

        [@body1, @body2].each { |body| body.run_callbacks(:post, self) }
      end
    end
  end
end