module Volt
  module Collision
    class Face
      attr_accessor :contact_loc
      attr_reader :start, :end
      attr_reader :normal, :axis

      def initialize(face_start, face_end)
        @start, @end = face_start, face_end

        @axis = @end - @start
        @normal = @axis.normal.unit
      end

      def correct_normal(verts1, verts2)
        d = get_centroid(verts1) - get_centroid(verts2)
        flip_normal if d.dot(@normal) > 0
      end

      def flip_normal
        @normal *= -1
      end
    end
  end
end