RSpec.describe Collision::SAT do

  describe '#the_thing' do

    # it 'Does the thing this way' do
    #   poly1_verts = [V.new(4, 2), V.new(6, 4), V.new(4, 6), V.new(2, 4)]
    #   poly2_verts = [V.new(7, 4), V.new(8, 6), V.new(5, 7), V.new(4, 5)]
    #
    #   manifold1 = get_manifold(poly1_verts, poly2_verts)
    #   loc1 = manifold1.calculate_location
    #
    #   poly3_verts = [V.new(5, 2), V.new(6, 4), V.new(3, 5), V.new(2, 3)]
    #   poly4_verts = [V.new(6, 3), V.new(8, 5), V.new(6, 7), V.new(4, 5)]
    #
    #   manifold2 = get_manifold(poly3_verts, poly4_verts)
    #   loc2 = manifold2.calculate_location
    #
    #   poly5_verts = [V.new(6, 2), V.new(6, 6), V.new(3, 6), V.new(2, 4)]
    #   poly6_verts = [V.new(5, 3), V.new(10, 3), V.new(10, 5), V.new(5, 5)]
    #
    #   manifold3 = get_manifold(poly5_verts, poly6_verts)
    #   loc3 = manifold3.calculate_location
    #
    #   binding.pry
    # end

    def get_manifold(verts1, verts2)
      manifold = Collision::Manifold.new

      Collision::SAT.check_for_poly_poly(verts1, verts2, manifold)
      Collision::SAT.check_for_poly_poly(verts2, verts1, manifold)
      Collision::SAT.find_contact_faces(verts1, verts2, manifold)
      Collision::Clip.from_manifold(manifold)

      manifold
    end
  end
end