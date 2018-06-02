module Volt
  class Joints
    class Rod < Joints

      def initialize(body1, body2, length)
        @body1, @body2 = body1, body2
        @length = length
      end

      def query
        return false if current_length.between?(@length - 0.001, @length + 0.001)

        Contact.new(@body1, @body2).tap do |contact|
          contact.contact_normal = (pos2 - pos1).unit
          contact.contact_normal.flip if current_length < @length

          contact.restitution = 0
          contact.penetration = current_length - @length
        end
      end
    end
  end
end