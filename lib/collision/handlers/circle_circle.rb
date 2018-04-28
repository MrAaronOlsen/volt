module Volt
  module Collision
    module Handlers
      class CircleCircle
        attr_reader :contact

        def initialize(circ1, circ2)
          @circ1 = circ1
          @circ2 = circ2
        end

        def query
          @center1 = @circ1.world_position(@circ1.centroid)
          @radius1 = @circ1.radius

          @center2 = @circ2.world_position(@circ2.centroid)
          @radius2 = @circ2.radius

          @penetration = (@radius1 + @radius2) - @center1.distance_to(@center2)
          @midline = @center1 - @center2

          @contact_loc = @center1 - (@midline.unit * @radius1)

          if @penetration > 0
            @contact = Contact.new(@circ1.body, @circ2.body)
            @contact.add_shapes(@circ1, @circ2)
            @contact.handler = self

            @contact.penetration = @penetration
            @contact.contact_normal = @midline.unit
            @contact.contact_loc = @contact_loc
          end
        end

        def debug
          Canvas::Pencil.circle(@contact_loc, 10, Canvas::Color.yellow, true, 2)
          Canvas::Pencil.line([@center1, @center2], Canvas::Color.red, 2)
        end
      end
    end
  end
end