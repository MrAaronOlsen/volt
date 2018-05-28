module Volt
  module Collision
    class Manifold
      attr_reader :penetration, :contact_normal, :contact_loc, :contact_face
      attr_reader :shape_a, :shape_b

      def penetration=(penetration)
        @penetration = penetration
      end

      def contact_normal=(contact_normal)
        @contact_normal = contact_normal
      end

      def contact_loc=(contact_loc)
        @contact_loc = contact_loc
      end

      def add_sat_data(penetration, normal, shape_a, shape_b)

        if @penetration.nil? || penetration < @penetration
          @penetration = penetration
          @contact_normal = normal
          @shape_a, @shape_b = shape_a, shape_b
        end
      end

      def flip_normal
        @contact_normal *= -1
      end

      def to_s
        "Penetration: #{@penetration}\n" +
        "Contact Normal: #{@contact_normal}"
      end
    end
  end
end