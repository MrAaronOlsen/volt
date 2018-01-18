module Volt
  class Shape
    class Tri < Shape

      def initialize(mass, v1, v2, v3)
        super()

        @verts << v1 << v2 << v3
        @mass = mass
        @type = "tri"
      end
    end
  end
end