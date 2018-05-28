module Volt
  module Collision
    class Manifold
      attr_accessor :penetration, :contact_normal, :contact_loc
      attr_accessor :reference, :incident
      attr_accessor :flipped

      def add_sat_data(penetration, normal)

        if @penetration.nil? || penetration < @penetration
          @penetration = penetration
          @contact_normal = normal
        end
      end

      def add_contact_faces(reference, incident)
        @reference, @incident = reference, incident
      end

      def flip
        @flipped = true
      end

      def flip_normal
        @contact_normal.flip
      end

      def avg_contact_loc
        @contact_loc.reduce(V.new) { |sum, v| sum + v } / @contact_loc.size
      end

      def mtv
        @contact_normal * @penetration
      end

      def calculate_location
        flipped ? avg_contact_loc - mtv : avg_contact_loc + mtv
      end
    end
  end
end