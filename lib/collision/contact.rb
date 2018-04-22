module Volt
  class Collision
    class Contact
      attr_reader :body1, :body2

      def initialize(body1, body2)
        @body1, @body2 = body1, body2
      end
    end
  end
end