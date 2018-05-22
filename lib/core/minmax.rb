module Volt
  class MinMax
    attr_reader :min, :max

    def initialize(min, max)
      @min, @max = min, max
    end

    class << self
      def by_projection(verts, axis)
        minmax = verts.map do |vert|
          vert.dot(axis).abs
        end.minmax

        MinMax.new(minmax[0], minmax[1])
      end
    end

  end
end