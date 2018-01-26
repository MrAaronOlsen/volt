module Canvas
  class Drawer
    attr_reader :debug

    def initialize(debug: false)
      @debug = :debug
    end

    def render(bodies)
      bodies.each { |body| render_body(body) }
    end

    def render_body(body)
      body.shapes.each do |shape|
        Draw.shape[shape.type].call(Sprite.new(shape))
      end

      render_debug(body) if @debug
    end

    def render_debug(body)
      Draw.shape[:poly].call(
        Sprite.new do |sprite|
          sprite.verts = body.hull.verts
          sprite.center = body.cog
          sprite.trans = body.trans
          sprite.fill = false
          sprite.color = Color.yellow
          sprite.z = 1
        end
      )
    end
  end
end