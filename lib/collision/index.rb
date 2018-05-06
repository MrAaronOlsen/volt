module Volt
  module Collision
    class Index

      def find_handler(shape1, shape2)
        if query[shape1.type].nil?
          return
        end

        handler = query[shape1.type][shape2.type]

        if handler.exists?
          handler = handler.call(shape1, shape2)
        else
          handler = query[shape2.type][shape1.type]

          if handler.exists?
            handler = handler.call(shape2, shape1)
          end
        end

        handler
      end

      def query
        {
          :circle => {
            circle: lambda { |circ1, circ2| Handlers::CircleCircle.new(circ1, circ2) },
          },
          :line => {
            circle: lambda { |line, circ| Handlers::LineCircle.new(line, circ) },
            line: lambda { |line1, line2| Handlers::LineLine.new(line1, line2) }
          },
          :rect => {
            circle: lambda { |rect, circ| Handlers::PolyCircle.new(rect, circ) },
            line: lambda { |rect, circ| Handlers::PolyLine.new(rect, circ) },
            rect: lambda { |rect1, rect2| Handlers::PolyPoly.new(rect1, rect2) },
            poly: lambda { |rect1, rect2| Handlers::PolyPoly.new(rect1, rect2) }
          },
          :poly => {
            circle: lambda { |rect, circ| Handlers::PolyCircle.new(rect, circ) },
            line: lambda { |rect, circ| Handlers::PolyLine.new(rect, circ) },
            rect: lambda { |rect1, rect2| Handlers::PolyPoly.new(rect1, rect2) },
            poly: lambda { |rect1, rect2| Handlers::PolyPoly.new(rect1, rect2) }
          }
        }
      end
    end
  end
end