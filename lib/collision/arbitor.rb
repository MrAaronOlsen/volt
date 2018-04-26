module Volt
  module Collision
    class Arbitor
      attr_reader :broad_contacts
      attr_reader :map

      def initialize
        @map = Handlers::Map.new
      end

      def query(bodies)
        @contacts = []

        bodies.each_with_index do |body, i|
          query_broad(body, bodies[i+1..-1])
        end

        narrow_collide
      end

      def resolve(dt)
        @contacts.each do |contact|
          contact.resolve(dt)
        end
      end

      def query_broad(body1, bodies)
        bodies.each do |body2|
          @contacts << Contact.new(body1, body2) if broad_collide?(body1, body2)
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

        distance - radius1 <= radius2 || distance - radius2 <= radius1
      end

      def narrow_collide
        @contacts.each do |contact|
          contact.body1.shapes.each do |shape1|
            contact.body2.shapes.each do |shape2|
              handler = @map.get_handler[shape1.type][shape2.type]

              if !handler.nil?
                if !handler.query(shape1, shape2, contact)
                  @contacts.delete(contact)
                end
              end
            end
          end
        end
      end
    end
  end
end