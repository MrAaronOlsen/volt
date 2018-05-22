module Volt
  module Collision
    class Face
      attr_reader :start, :end, :normal

      def initialize(face_start, face_end)
        @start, @end = face_start, face_end
      end
    end
  end
end