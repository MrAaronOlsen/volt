module Volt
  class Joints
    class Cable < Joints

      def initialize(body1, body2, length, restitution)
        @body1, @body2 = body1, body2
        @length = length
        @restitution = restitution
      end

      def query
        return false if current_length < @length

        @manifold = Collision::Manifold.new do |man|
          man.is_joint = true
          man.body1_contact_loc = pos1
          man.body2_contact_loc = pos2
          man.contact_normal = (pos2 - pos1).unit
          man.penetration = current_length - @length
          man.restitution = @restitution
        end

        return true
      end

      def get_contact
        Collision::Contact.new(@manifold) do |contact|
          contact.add_bodies(@body1, @body2)
        end
      end
    end
  end
end