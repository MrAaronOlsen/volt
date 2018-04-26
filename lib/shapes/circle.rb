module Volt
  class Shape
    class Circle < Shape

      def initialize
        super(:circle)

        yield self
      end

      def set_verts(center, radius)
        @radius = radius
        @center = center

        x = @center.x
        y = @center.y

        @verts = [
          V.new(x - radius, y),
          V.new(x, y - radius),
          V.new(x + radius, y),
          V.new(x, y + radius)
        ]
      end
    end
  end
end