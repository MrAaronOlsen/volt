module Volt
  module Collision
    module Handlers
      class PolyPoly < Base
        attr_reader :type

        def initialize(rect1, rect2)
          @rect1, @rect2 = rect1, rect2
        end

        def query
        end
      end
    end
  end
end