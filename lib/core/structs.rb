require 'ostruct'

module Volt
  module Structs
    ContactFaces = Struct.new(:reference, :incident)
    PointAlongAxis = Struct.new(:distance, :point)
    BroadContact = Struct.new(:body1, :body2)

    Face = Struct.new(:start, :end) do
      attr_accessor :start, :end
      attr_accessor :axis, :normal

      def initialize(line_start, line_end)
        @start, @end = line_start, line_end
      end

      def axis
        @axis ||= @end - @start
      end

      def normal
        @normal ||= (@end - @start).normal.unit
      end
    end
  end
end