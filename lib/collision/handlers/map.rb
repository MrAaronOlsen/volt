module Volt
  module Collision
    module Handlers
      class Map

        def get_handler(shape1, shape2)
          handler = collision_map[shape1.type][shape2.type]

          if handler.nil?
            handler = collision_map[shape2.type][shape1.type]

            if handler.exists?
              handler = handler.call(shape2, shape1)
            end
          else
            handler = handler.call(shape1, shape2)
          end

          handler
        end

        def collision_map
          {
            :circle => { circle: lambda { |circ1, circ2| CircleCircle.new(circ1, circ2) } },
            :line => { circle: lambda { |line, circ| LineCircle.new(line, circ) } }
          }
        end
      end
    end
  end
end