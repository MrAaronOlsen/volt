module Volt
  module Collision
    class Arbitor
      attr_reader :broad_contacts, :narrow_contacts
      attr_reader :handler

      def initialize
        @handler = Handler.new
      end

      def query(bodies)
        @broad_contacts = []
        @narrow_contacts = []

        collect_broad_contacts(bodies)
        collect_narrow_contacts
      end

      def resolve(dt)
        @narrow_contacts.each do |contact|
          contact.resolve(dt)
        end
      end

      def collect_broad_contacts(bodies)
        bodies.each_with_index do |body1, i|
          bodies[i+1..-1].each do |body2|
            @broad_contacts << Contact.new(body1, body2) if broad_collide?(body1, body2)
          end
        end
      end

      def broad_collide?(body1, body2)
        b1 = body1.bounding
        b2 = body2.bounding

        center1 = body1.trans.transform_vert(b1.center)
        radius1 = b1.radius
        center2 = body2.trans.transform_vert(b2.center)
        radius2 = b2.radius

        distance = center1.distance_to(center2)

        (radius1 + radius2) - distance > 0
      end

      def collect_narrow_contacts
        @broad_contacts.each do |contact|
          contact.body1.shapes.each do |shape1|
            next if shape1.static

            contact.body2.shapes.each do |shape2|
              next if shape2.static

              handler = @handler.get(shape1, shape2)

              if handler.exists? && handler.query
                @narrow_contacts << handler.get_contact
              end
            end
          end
        end
      end
    end
  end
end