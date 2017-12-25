module Volt
  class Shape
    attr_accessor :centroid, :points, :body

    def initialize
      @points = []
      @offset = Vect.new
      @centroid = Vect.new
    end

    def set_body(body)
      @body = body
    end
  end

  class Box < Shape

    def initialize(width, height)
      super()

      @points << Vect.new
      @points << Vect.new(width, 0)
      @points << Vect.new(width, height)
      @points << Vect.new(0, height)

      @centroid.add(@points[1] / 2)
      @centroid.add(@points[3] / 2)
    end
  end
end