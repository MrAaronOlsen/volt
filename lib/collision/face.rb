module Volt
  module Collision
    class Face
      attr_accessor :contact_loc
      attr_reader :start, :end, :normal

      def initialize(face_start, face_end)
        @start, @end = face_start, face_end
      end

      def normal
        (@end - @start).normal.unit
      end

      def axis
        (@end - @start).unit
      end
    end
  end
end