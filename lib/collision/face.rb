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

      def to_s
        "Start: #{@start}\n" +
        "End: #{@end}\n" +
        "Axis: #{@axis}\n" +
        "Normal: #{@normal}"
      end
    end
  end
end