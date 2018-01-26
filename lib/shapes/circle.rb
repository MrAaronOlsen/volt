module Volt
  class Shape
    class Circle < Shape

      def initialize
        super(:circle)

        yield self
      end

      def radius=(radius)
        @radius = radius
      end
    end
  end
end