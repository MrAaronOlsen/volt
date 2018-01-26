module Canvas
  class Sprite
    attr_accessor :shape
    attr_accessor :verts, :center, :trans
    attr_accessor :color, :fill, :z

    def initialize(shape = nil)
      @shape = shape

      if block_given? then yield(self) else set_on_shape end
    end

    def verts
      @verts.map { |vert| @trans.transform_vert(vert)}
    end

    def center
      @trans.transform_vert(@center)
    end

    def set_on_shape
      @verts = @shape.verts
      @center = @shape.centroid
      @trans = @shape.body.trans
      @color = @shape.color
      @fill = @shape.fill
      @z = @shape.z
    end
  end
end