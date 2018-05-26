module Volt
  class Shape
    class Line < Shape

      def initialize
        super(:line)

        yield self
      end

      def set_verts(v1, v2)
        @verts = [v1, v2]
      end
    end
  end
end