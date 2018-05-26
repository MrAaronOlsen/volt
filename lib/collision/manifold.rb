module Volt
  module Collision
    class Manifold
      attr_reader :penetration, :contact_normal, :contact_loc, :contact_face

      def penetration=(penetration)
        @penetration = penetration
      end

      def contact_normal=(contact_normal)
        @contact_normal = contact_normal
      end

      def contact_loc=(contact_loc)
        @contact_loc = contact_loc
      end

      def add_sat_data(penetration, normal)

        if @penetration.nil? || penetration < @penetration
          @penetration = penetration
          @contact_normal = normal
        end
      end
    end
  end
end