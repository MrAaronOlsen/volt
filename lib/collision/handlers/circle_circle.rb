module Volt
  module Collision
    class CircleCircle

      def initialize(circ1, circ2)
        @circ1, @circ2 = circ1, circ2
      end

      def query
        @center1 = Ref.get(@circ1.body, @circ1.centroid)
        @radius1 = @circ1.radius

        @center1 = Ref.get(@circ2.body, @circ2.centroid)
        @radius2 = @circ2.radius

        @thread = @center1 - @center2

        @penetration = (@radius1 + @radius2) - @center1.distance_to(@center2)

        @contact_loc = @center1 - (@thread.unit * @radius1)
        @contact_normal = @thread.unit

        @penetration > 0
      end

      def get_contact
        Contact.new(@circ1, @circ2) do |contact|
          contact.handler = self
          contact.penetration = @penetration
          contact.contact_normal = @contact_normal
          contact.contact_loc = @contact_loc
        end
      end
    end
  end
end