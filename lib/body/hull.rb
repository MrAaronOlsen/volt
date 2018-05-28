module Volt
  class Hull
    attr_reader :verts

    def initialize(points)
      @verts = wrap_hull(sorted(points))
    end

    def sorted(points)
      points.sort_by { |point| point.x }
    end

    def wrap_hull(points)
      total = points.count
      a = 0

      Array.new.tap do |hull|
        loop do
          hull << points[a]
          b = (a + 1) % total

          points.each_index do |c|
            b = c if Geo.determinant(points[a], points[b], points[c]) == 1
          end

          b.zero? ? break : a = b
        end
      end
    end
  end
end