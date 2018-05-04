module Volt
  module Collision
    class Handler

      def get(shape1, shape2)
        if sieve[shape1.type].nil?
          return
        end
        
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
          :circle => {
            circle: lambda { |circ1, circ2| Handlers::CircleCircle.new(circ1, circ2) },
          },
          :line => {
            circle: lambda { |line, circ| Handlers::LineCircle.new(line, circ) },
            line: lambda { |line1, line2| Handlers::LineLine.new(line1, line2) }
          },
          :rect => {
            circle: lambda { |rect, circ| Handlers::RectCircle.new(rect, circ) },
            line: lambda { |rect, circ| Handlers::RectLine.new(rect, circ) },
            rect: lambda { |rect1, rect2| Handlers::RectRect.new(rect1, rect2) }
          }
        }
      end
    end
  end
end