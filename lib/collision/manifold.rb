module Volt
  module Collision
    class Manifold
      attr_accessor :penetration, :contact_normal
      attr_accessor :reference, :incident
      attr_accessor :contact_loc

      def add_sat_data(penetration, normal)

        if @penetration.nil? || penetration < @penetration
          @penetration = penetration
          @contact_normal = normal
        end
      end

      def add_contact_faces(reference, incident)
        @reference, @incident = reference, incident
      end

      def flip_normal
        @contact_normal *= -1
      end
    end
  end
end