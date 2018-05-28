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

      @centroid = Geo.get_centroid(@verts)
    end
  end
end