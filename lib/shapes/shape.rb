module Volt
  class Shape
    attr_reader :centroid, :verts
    attr_reader :type, :mass, :body

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

    def offset(offset)
      @verts.each do |vert|
        vert.sub(offset)
      end
    end
  end
end