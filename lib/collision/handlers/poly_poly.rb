module Volt
  module Collision
    class PolyPoly

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

        true
      end

      def get_contact
        Contact.new(@poly1, @poly2) do |contact|
          contact.penetration = @manifold.penetration
          contact.contact_normal = @manifold.contact_normal *= -1
          contact.contact_loc = @manifold.calculate_location
          contact.reference_face = @manifold.reference
          contact.incident_face = @manifold.incident
        end
      end
    end
  end
end