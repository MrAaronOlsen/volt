module Volt
  class Joints
    class Rod < Joints

      def initialize(body1, body2, length)
        @body1, @body2 = body1, body2
        @length = length
      end

      def query
        return false if current_length.between?(@length - 0.001, @length + 0.001)

        @manifold = Contact::Manifold.new do |man|
          man.body1_contact_loc = pos1
          man.body2_contact_loc = pos2
          man.penetration = current_length - @length
          man.contact_normal = (pos2 - pos1).unit
          man.restitution = 0

          man.contact_normal.flip if current_length < @length
        end

        true
      end

      def manifold
        @manifold.tap do |man|
          man.add_bodies(@body1, @body2)
        end
      end
    end
  end
end