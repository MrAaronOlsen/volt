require 'ostruct'

module Volt
  module Structs
    ContactFaces = Struct.new(:reference, :incident)
    PointAlongAxis = Struct.new(:distance, :point)
    BroadContact = Struct.new(:body1, :body2)

    Edge = Struct.new(:from, :to) do
      attr_accessor :axis, :normal

      def axis
        @axis ||= to - from
      end

      def normal
        @normal ||= (to - from).normal.unit
      end
    end
  end
end