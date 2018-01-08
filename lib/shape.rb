module Volt
  class Shape
    attr_accessor :centroid, :verts, :mass, :body

    def initialize
      @verts = []
      @centroid = Vect.new
    end

    def set_body(body)
      @body = body
      body.add_shape(self)
    end

    def world_verts
      @verts.map do |vert|
        @body.transform.of_vert(vert)
      end
    end

    def world_centroid
      verts = world_verts
      sum = 0.0
      v_sum = Vect.new

      verts.each_with_index do |vert, i|
      	vert2 = verts[(i+1) % verts.count]
      	cross = vert.cross(vert2)

      	sum += cross
      	v_sum = v_sum + ( (vert + vert2) * cross )
      end

      v_sum * 1.0/(3.0*sum)
    end
  end

  class Box < Shape

    def initialize(width, height, offset, mass)
      super()

      @verts << Vect.new(offset.x, offset.y)
      @verts << Vect.new(width + offset.x, offset.y)
      @verts << Vect.new(width + offset.x, height + offset.y)
      @verts << Vect.new(offset.x, height + offset.y)

      @mass = mass
    end
  end

  class Poly < Shape

    def initialize(*verts, mass)
      super()

      @verts = verts
      @mass = mass
    end
  end
end