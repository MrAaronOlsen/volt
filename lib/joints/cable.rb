module Volt
  class Joint
    class Cable < Joints

      def initialize(body1, body2, length, restitution)
        @body1, @body2 = body1, body2
        @length = length
        @restitution = restitution
      end

      def query
        return false if current_length < @length

        Contact.new(@body1, @body2).tap do |contact|
          contact.contact_normal = (pos2 - pos1).unit
          contact.penetration = current_length - @length
          contact.restitution = restitution
        end
      end
    end
  end
end