module Canvas
  class Drawer
    attr_reader :debug

    def initialize(debug: false)
      @debug = debug
    end

    def render(bodies)
      bodies.each { |body| render_body(body) }
    end

    def flip_debug
      @debug ? (@debug = false) : (@debug = true)
    end

    def render_body(body)
      body.shapes.each do |shape|
        Draw.shape[shape.type].call(Sprite.new(shape))
      end

      render_debug(body) if @debug
    end

    def render_debug(body)
      Draw.shape[:poly].call(hull_sprite(body))
      Draw.shape[:circle].call(bounding_sprite(body))
    end

    def hull_sprite(body)
      Sprite.new do |sprite|
        sprite.verts = body.hull.verts
        sprite.center = body.cog
        sprite.trans = body.trans
        sprite.fill = false
        sprite.color = Color.yellow
        sprite.z = 1
      end
    end

    def bounding_sprite(body)
      Sprite.new do |sprite|
        sprite.center = body.bounding.circle.center
        sprite.radius = body.bounding.circle.radius
        sprite.trans = body.trans
        sprite.fill = false
        sprite.color = Color.green
        sprite.z = 1
      end
    end
  end
end