module Volt
  class Shape
    attr_reader :name
    attr_reader :centroid, :verts, :radius
    attr_reader :type, :static, :mass, :body
    attr_reader :color, :fill, :z

    def initialize(type)
      @type = type
      @static = false
      @color, @fill, @z = 0xFF_FFFFFF, true, 1
      @mass, @centroid, @verts = 0, Vect.new, []
    end

    def world_position(vect)
      @body.trans.transform_vert(vect)
    end

    def name=(name)
      @name = name
    end

    def body=(body)
      @body = body
      body.add_shape(self)
    end

    def mass=(mass)
      @mass = mass
    end

    def fill=(fill)
      @fill = fill
    end

    def color=(color)
      @color = color
    end

    def z=(z)
      @z = z
    end

    def static=(static)
      @static = static
    end

    def transform(trans)
      @verts.each do |vert|
        vert.transform(trans)
      end

      set_centroid
    end

  private

    def set_centroid
      sum = 0.0
      v_sum = Vect.new

      @verts.each_with_index do |vert, i|
      	vert2 = verts[(i+1) % verts.count]
      	cross = vert.cross(vert2)

      	sum += cross
      	v_sum += (vert + vert2) * cross
      end

      if (sum.zero?)
        @centroid = v_sum
      else
        @centroid = v_sum * 1.0/(3.0*sum)
      end
    end
  end
end