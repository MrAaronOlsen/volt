module Volt
  class Shape
    attr_accessor :centroid, :verts, :body

    def initialize
      @verts = []
      @centroid = Vect.new
      @translate = Mat23.new_identity
    end

    def set_body(body)
      @body = body
      body.add_shape(self)
    end

    def get_world_verts
      @translate = Mat23.new_translate(@body.pos)

      @verts.map do |vert|
        @translate.transform_vert(vert)
      end
    end

    def get_world_centroid
      world_verts = get_world_verts
      sum = 0.0
      v_sum = Vect.new

      world_verts.each_with_index do |vert, i|
      	vert2 = world_verts[(i+1) % world_verts.count]
      	cross = vert.cross(vert2)

      	sum += cross
      	v_sum = v_sum + ( (vert + vert2) * cross )
      end

      v_sum * 1.0/(3.0*sum)
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