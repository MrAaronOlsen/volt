module Canvas
  class Sprite
    attr_accessor :shape, :verts, :trans, :use_transform
    attr_accessor :centroid, :center, :radius
    attr_accessor :color, :fill, :z

    def initialize(shape = nil)
      @shape = shape
      @use_transform = true

      if block_given? then yield(self) else set_on_shape end
    end

    def verts
      @use_transform ? @verts.map { |vert| @trans.transform_vert(vert) } : @verts
    end

    def center
      @use_transform ? @trans.transform_vert(@center) : @center
    end

    def set_on_shape
      @center = @shape.centroid
      @verts = @shape.verts
      @radius = @shape.radius
      @trans = @shape.body.trans
      @color = @shape.color
      @fill = @shape.fill
      @z = @shape.z
    end
  end
end