module Canvas
  class Drawer
    attr_reader :debug

    def initialize(debug: false)
      @debug = debug
    end

    def render(scene)
      scene.world.bodies.each do |body|
        render_body(body)
      end

      return unless @debug

      scene.contacts.each do |contact|
        Canvas::Pencil.circle(contact.contact_loc, 10, Canvas::Color.yellow, true, 2)
      end
    end

    def flip_debug
      @debug ? (@debug = false) : (@debug = true)
    end

    def render_body(body)
      body.shapes.each do |shape|
        Draw.shape[shape.type].call(Sprite.new(shape))
      end

      return unless @debug
      render_debug(body)
    end

    def render_debug(body)
      Draw.shape[:poly].call(hull_sprite(body))
      Draw.shape[:rect].call(bounding_sprite(body))
    end

    def hull_sprite(body)
      Sprite.new do |sprite|
        sprite.verts = body.hull.verts
        sprite.center = body.cog
        sprite.trans = body.trans
        sprite.fill = false
        sprite.color = Color.red
        sprite.z = 1
      end
    end

    def bounding_sprite(body)
      Sprite.new do |sprite|
        sprite.verts = body.bounding.corners
        sprite.center = body.cog
        sprite.use_transform = false
        sprite.fill = false
        sprite.color = Color.green
        sprite.z = 1
      end
    end
  end
end