RSpec.describe Collision::SAT do

  describe '#the_thing' do

    it 'Does the thing this way' do
      poly1_verts = [V.new(4, 2), V.new(6, 4), V.new(4, 6), V.new(2, 4)]
      poly2_verts = [V.new(7, 4), V.new(8, 6), V.new(5, 7), V.new(4, 5)]

      manifold = Collision::Manifold.new
      Collision::SAT.check_for_poly_poly(poly1_verts, poly2_verts, manifold)
      Collision::SAT.check_for_poly_poly(poly2_verts, poly1_verts, manifold)
      Collision::SAT.find_contact_faces(poly1_verts, poly2_verts, manifold)

      binding.pry
    end
  end
end


def clip(poly1_verts, poly2_verts, manifold)
  axis = manifold.contact_normal


end

