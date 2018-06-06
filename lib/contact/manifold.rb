module Volt
  module Contact
    class Manifold
      attr_accessor :penetration, :contact_normal, :restitution
      attr_accessor :body1, :body2
      attr_accessor :body1_contact_loc, :body2_contact_loc, :contact_locs
      attr_accessor :reference, :incident
      attr_accessor :flipped, :is_dummy

      def initialize
        @restitution = 0.8

        yield(self) if block_given?
      end

      def add_sat_data(penetration, normal)

        if @penetration.nil? || penetration < @penetration
          @penetration = penetration
          @contact_normal = normal
        end
      end

      def add_contact_faces(reference, incident)
        @reference, @incident = reference, incident
      end

      def add_bodies(body1, body2)
        @body1, @body2 = body1, body2
      end

      def add_shapes(shape1, shape2)
        @shape1, @shape2 = shape1, shape2
      end

      def flip
        @flipped = true
      end

      def flip_normal
        @contact_normal.flip
      end

      def contact_loc=(contact_loc)
        @body1_contact_loc = contact_loc
        @body2_contact_loc = contact_loc
      end

      def mtv
        @contact_normal * @penetration
      end

      def resolve(dt)
        [@body1, @body2].each { |body| body.run_callbacks(:pre, self) }
        return if @is_dummy

        Impulse.resolve_interpenetration(self, dt)
        Impulse.resolve_velocity(self, dt)

        [@body1, @body2].each { |body| body.run_callbacks(:post, self) }
      end
    end
  end
end