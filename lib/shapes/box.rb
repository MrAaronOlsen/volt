module Volt
  class Shape
    class Box < Shape

      def initialize(width, height, offset, mass)
        super()

        @verts << Vect.new(offset.x, offset.y)
        @verts << Vect.new(width + offset.x, offset.y)
        @verts << Vect.new(width + offset.x, height + offset.y)
        @verts << Vect.new(offset.x, height + offset.y)

        @mass = mass
        @type = "box"
      end
    end
  end
end