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

        x = @center.x - radius
        y = @center.y

        @verts = [
          V.with_rotation(x, y, 45),
          V.with_rotation(x, y, 135),
          V.with_rotation(x, y, 225),
          V.with_rotation(x, y, 315) ]
      end
    end
  end
end