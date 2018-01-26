module Volt
  class Bounding
    class Circle
      attr_reader :body, :center, :radius

      def initialize(body)
        @body = body
      end
    end
  end
end