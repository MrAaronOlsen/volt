module Volt
  class Shape
    class Circle < Shape

      def initialize
        super(:circle)

        yield self
      end

      def set_verts(center, radius)
        @radius = radius

        x = center.x
        y = center.y

        @verts = [
          V.new(x - radius, y - radius),
          V.new(x + radius, y - radius),
          V.new(x + radius, y + radius),
          V.new(x - radius, y + radius)
        ]
      end
    end
  end
end