module Volt
  module Collision
    class PolyPoly < Base

      def initialize(poly1, poly2)
        @poly1, @poly2 = poly1, poly2
      end

      def query
        manifold = Manifold.new
        poly1_verts = Ref.get_all(@poly1.body, @poly1.verts)
        poly2_verts = Ref.get_all(@poly2.body, @poly2.verts)

        unless SAT.check_for_poly_poly(poly1_verts, poly2_verts, manifold)
          puts "Gap Found".blue
          return false
        end

        unless SAT.check_for_poly_poly(poly2_verts, poly1_verts, manifold)
          puts "Gap Found".red
          return false
        end

        puts "Min Penetration is #{manifold.penetration}".green
        puts "Contact Normal #{manifold.contact_normal}".green

        @penetration = manifold.penetration
        @contact_normal = manifold.contact_normal
        @contact_loc = V.new(200, 200)

        true
      end

      def get_contact
        Contact.new(@poly1, @poly2) do |contact|
          contact.dummy = true
          contact.penetration = @penetration
          contact.contact_normal = @contact_normal
          contact.contact_loc = @contact_loc
          contact.contact_face = @contact_face
        end
      end
    end
  end
end