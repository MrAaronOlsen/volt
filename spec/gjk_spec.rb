RSpec.describe Collision::SAT do
  include Collision::Handlers::Base

  describe '#minkowski_difference' do
    it 'Finds the Difference' do
      poly1_verts = [V.new(4, 11), V.new(9, 9), V.new(4, 5)]
      poly2_verts = [V.new(5, 7), V.new(12, 7), V.new(10, 2), V.new(7, 3)]

      minkowski_difference = minkowski_difference(poly1_verts, poly2_verts)
    end
  end

  describe '#sat_check_for_poly_poly' do
    it 'Finds the incident face and penetration' do
      # poly1_verts = [V.new(1, 1), V.new(4, 1), V.new(4, 4), V.new(1, 4)]
      # poly2_verts = [V.new(2, 3), V.new(5, 3), V.new(5, 6), V.new(2, 6)]

      poly1_verts = [V.new(3, 1), V.new(5, 3), V.new(3, 5), V.new(1, 3)]
      poly2_verts = [V.new(3, 4), V.new(7, 4), V.new(6, 6), V.new(4, 6)]

      manifold = Collision::Manifold.new
      Collision::SAT.check_for_poly_poly(poly1_verts, poly2_verts, manifold)
      Collision::SAT.check_for_poly_poly(poly2_verts, poly1_verts, manifold)

      faces = find_contact_faces(poly1_verts, poly2_verts, manifold.contact_normal)
      binding.pry
    end
  end

  describe '#get_centroid' do
    it 'Finds the centroid' do
      poly1_verts = [V.new(3, 1), V.new(5, 3), V.new(3, 5), V.new(1, 3)]

      get_the_centroid(poly1_verts)
    end
  end

end

def get_the_centroid(verts)
  size = verts.size
  centroid = V.new

  verts.each { |vert| centroid += vert / verts.size }
  reduced = verts.reduce(V.new) { |sum, vert| sum += vert / verts.size }
end

def find_contact_face(poly_verts, axis, direction = true)
  points = Array.new
  distance = nil

  poly_verts.each do |vert|
    points << Struct.new(:vert, :distance).new(vert, distance_along_axis(axis, vert))
  end

  if direction
    points = points.max_by(2) { |point| point.distance.abs }
  else
    points = points.min_by(2) { |point| point.distance.abs }
  end

  Collision::Face.new(points[0].vert, points[1].vert)
end

def clip(poly1_verts, poly2_verts, manifold)
  axis = manifold.contact_normal


end

def minkowski_difference(poly1_verts, poly2_verts)
  dif = Array.new

  poly1_verts.each do |vert1|
    dif += poly2_verts.map do |vert2|
      vert1 - vert2
    end
  end
end