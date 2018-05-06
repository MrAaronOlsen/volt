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
            line: lambda { |line1, line2| Handlers::LineLine.new(line1, line2) },
            tri: lambda { |line, tri| Handlers::PolyLine.new(tri, line) },
          },
          :tri => {
            tri: lambda { |tri1, tri2| Handlers::PolyPoly.new(tri1, tri2) }
          },
          :rect => {
            circle: lambda { |rect, circ| Handlers::PolyCircle.new(rect, circ) },
            line: lambda { |rect, circ| Handlers::PolyLine.new(rect, circ) },
            tri: lambda { |rect, tri| Handlers::PolyPoly.new(rect, tri) },
            rect: lambda { |rect1, rect2| Handlers::PolyPoly.new(rect1, rect2) }
          },
          :poly => {
            circle: lambda { |poly, circ| Handlers::PolyCircle.new(poly, circ) },
            line: lambda { |poly, circ| Handlers::PolyLine.new(poly, circ) },
            tri: lambda { |poly, tri| Handlers::PolyPoly.new(poly, tri) },
            rect: lambda { |poly, rect| Handlers::PolyPoly.new(poly, rect) },
            poly: lambda { |poly1, poly2| Handlers::PolyPoly.new(poly1, poly2) }
          }
        }
      end
    end
  end
end