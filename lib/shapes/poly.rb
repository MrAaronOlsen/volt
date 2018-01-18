module Volt
  class Shape
    class Poly < Shape

      def initialize(mass, *verts)
        super()

        @verts = verts
        @mass = mass
        @type = "poly"
      end
    end
  end
end