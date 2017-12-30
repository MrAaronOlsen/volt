module Volt
  class Shape
    attr_accessor :centroid, :verts, :body

    def initialize
      @verts = []
      @centroid = Vect.new
    end

    def set_body(body)
      @body = body
      body.add_shape(self)

      reset
    end

    def reset
      update_centroid
    end

    def update_centroid
      sum = 0.0
      v_sum = Vect.new

      @verts.each_with_index do |vert, i|
      	vert2 = @verts[(i+1) % @verts.count]
      	cross = vert.cross(vert2)

      	sum += cross
      	v_sum = v_sum + ( (vert + vert2) * cross )
      end

      @centroid = v_sum * 1.0/(3.0*sum)
    end
  end

  class Box < Shape

    def initialize(width, height)
      super()

      @verts << Vect.new
      @verts << Vect.new(width, 0)
      @verts << Vect.new(width, height)
      @verts << Vect.new(0, height)
    end
  end

  class Poly < Shape

    def initialize(*verts)
      super()

      @verts = verts
    end
  end
end