module Volt
  module Collision
    module Handlers
      class Map
        attr_reader :CircleCircle

        def initialize
          @CircleCircle = CircleCircle.new
        end

        def get_handler
          {
            :circle => { :circle => @CircleCircle },
            :cirlce => { :line => nil },
            :line => { :circle => nil }
          }
        end
      end
    end
  end
end