module Volt
  module Geometry

    # Find the geometric center of a convex polygon
    def get_centroid(verts)
      size = verts.size
      verts.reduce(V.new) { |sum, vert| sum += vert / verts.size }
    end

    # Returns the distance of a point along a particulat axis
    def distance_along_axis(point, axis)
      axis.dot(point)
    end

    # Returns 1 if b is to the right of a in reference to o
    def determinant(o, a, b)
      d = (a.y - o.y) * (b.x - a.x) - (b.y - a.y) * (a.x - o.x)
      return 0 if d.zero?

      d <=> 0
    end

    # Linear Interpolation
    def lerp(line_start, line_end, alpha)
      line_start * (1 - alpha) + line_end * alpha
    end

    # Convert a degree to a radian
    def radian(degree)
       degree*(Math::PI/180)
    end
  end
end