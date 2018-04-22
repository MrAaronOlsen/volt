module Volt
  class Shape
    class Rect < Shape

      def initialize
        super(:rect)

        yield self
      end

      def set_verts(width, height, offset = V.new)
        @verts << Vect.new(offset.x, offset.y)
        @verts << Vect.new(width + offset.x, offset.y)
        @verts << Vect.new(width + offset.x, height + offset.y)
        @verts << Vect.new(offset.x, height + offset.y)
      end
    end
  end
end