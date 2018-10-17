module Volt
  module Contact
    class CircleCircle
      attr_reader :manifold

      def initialize(circ1, circ2)
        @circ1, @circ2 = circ1, circ2
      end

      def query
        center1 = Ref.get(@circ1.body.trans, @circ1.centroid)
        radius1 = @circ1.radius

        center2 = Ref.get(@circ2.body.trans, @circ2.centroid)
        radius2 = @circ2.radius

        d = center1 - center2

        penetration = (radius1 + radius2) - center1.distance_to(center2)

        return false if penetration <= 0.0

        @manifold = Manifold.new do |man|
          man.penetration = penetration
          man.contact_normal = d.unit
          man.contact_loc = (center1 * radius2 + center2 * radius1) / (radius1 + radius2)
        end

        return true
      end

      def manifold
        @manifold.tap do |man|
          man.add_bodies(@circ1.body, @circ2.body)
        end
      end
    end
  end
end