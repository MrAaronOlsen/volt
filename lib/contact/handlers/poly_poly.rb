module Volt
  module Contact
    class PolyPoly
      attr_reader :manifold

      def initialize(poly1, poly2)
        @poly1, @poly2 = poly1, poly2
      end

      def query
        @manifold = Manifold.new

        poly1_verts = Ref.get_all(@poly1.body.trans, @poly1.verts)
        poly2_verts = Ref.get_all(@poly2.body.trans, @poly2.verts)

        return false unless SAT.check_for_poly_poly(poly1_verts, poly2_verts, @manifold)
        return false unless SAT.check_for_poly_poly(poly2_verts, poly1_verts, @manifold)

        SAT.find_contact_faces(poly1_verts, poly2_verts, @manifold)
        Clip.from_manifold(@manifold)

        contact_loc = Geo.average_vector(@manifold.contact_locs)

        if @manifold.flipped
          @manifold.contact_loc = contact_loc - @manifold.mtv
        else
          @manifold.contact_loc = contact_loc + @manifold.mtv
        end

        true
      end

      def manifold
        @manifold.tap do |man|
          man.add_bodies(@poly2.body, @poly1.body)
        end
      end
    end
  end
end