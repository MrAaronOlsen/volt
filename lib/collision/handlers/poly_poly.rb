module Volt
  module Collision
    class PolyPoly

      def initialize(poly1, poly2)
        @poly1, @poly2 = poly1, poly2
      end

      def query
        manifold = Manifold.new
        poly1_verts = Ref.get_all(@poly1.body.trans, @poly1.verts)
        poly1_cen = Ref.get(@poly1.body.trans, @poly1.centroid)

        poly2_verts = Ref.get_all(@poly2.body.trans, @poly2.verts)
        poly2_cen = Ref.get(@poly2.body.trans, @poly2.centroid)

        return false unless SAT.check_for_poly_poly(poly1_verts, poly2_verts, manifold)
        return false unless SAT.check_for_poly_poly(poly2_verts, poly1_verts, manifold)

        @penetration = manifold.penetration
        @contact_normal = manifold.contact_normal

        @contact_face = SAT.find_contact_faces(poly1_verts, poly2_verts, manifold.contact_normal)
        @contact_loc = V.new(200, 200)

        true
      end

      def get_contact
        Contact.new(@poly1, @poly2) do |contact|
          contact.dummy = true
          contact.penetration = @penetration
          contact.contact_normal = @contact_normal
          contact.contact_loc = @contact_loc
          contact.reference_face = @contact_face.reference
          contact.incident_face = @contact_face.incident
        end
      end
    end
  end
end