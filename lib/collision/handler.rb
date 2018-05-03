module Volt
  module Collision
    class Handler

      def get(shape1, shape2)
        handler = sieve[shape1.type][shape2.type]

        if handler.nil?
          handler = sieve[shape2.type][shape1.type]

          if handler.exists?
            handler = handler.call(shape2, shape1)
          end
        else
          handler = handler.call(shape1, shape2)
        end

        handler
      end

      def sieve
        {
          :circle => { circle: lambda { |circ1, circ2| Handlers::CircleCircle.new(circ1, circ2) } },
          :line => { circle: lambda { |line, circ| Handlers::LineCircle.new(line, circ) } },
          :rect => {
            circle: lambda { |rect, circ| Handlers::RectCircle.new(rect, circ) },
            line: lambda { |rect, circ| Handlers::RectLine.new(rect, circ) }
          }
        }
      end
    end
  end
end