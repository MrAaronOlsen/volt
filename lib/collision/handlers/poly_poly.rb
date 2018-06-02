module Volt
  module Collision
    class PolyPoly
      attr_reader :manifold

      def initialize(poly1, poly2)
        @poly1, @poly2 = poly1, poly2
      end

      def query
        @manifold = Manifold.new(@poly2, @poly1)

        poly1_verts = Ref.get_all(@poly1.body.trans, @poly1.verts)
        poly2_verts = Ref.get_all(@poly2.body.trans, @poly2.verts)

        return false unless SAT.check_for_poly_poly(poly1_verts, poly2_verts, @manifold)
        return false unless SAT.check_for_poly_poly(poly2_verts, poly1_verts, @manifold)

        SAT.find_contact_faces(poly1_verts, poly2_verts, @manifold)
        Clip.from_manifold(@manifold)

        @manifold.calculate_location
        true
      end

      def get_contact
        Contact.new(@manifold)
      end
    end
  end
end