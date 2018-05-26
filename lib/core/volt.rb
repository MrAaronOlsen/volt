module Volt
  def get_centroid(verts)
    size = verts.size

    verts.reduce(V.new) { |sum, vert| sum += vert / verts.size }
  end
end

$debug = false

class Object
  def exists?
    !self.nil?
  end
end