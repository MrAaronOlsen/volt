class Poly
  attr_reader :body, :parts, :scene

  def initialize(pos, angle, scene)
    @body = new_box(pos)
    @scene = scene
    build(angle)
  end

  def new_box(pos)
    Body.new do |b|
			b.pos = pos
			b.mass = 3
			b.moment = 300
		end
  end

  def build(angle)
    @parts = [poly]

    @body.init
    @body.recenter
    @body.rotate(angle)

    add_contact_effect
  end

  def go
    @body.add_impulse(V.from_angle(@body.angle) * 100)
  end

  def stop
    @body.add_force(V.from_angle(@body.angle) * -200) if @body.vel.mag > 0
  end

  def right
    @body.add_rotation(4)
  end

  def left
    @body.add_rotation(-4)
  end

  def freeze
    @body.set_vel(V.new(0, 0))
    @body.set_a_vel(0)
  end

  def add_contact_effect
    @body.add_callback_block(:post) do |body, contact|

      sprite = Canvas::Sprite.new do |sprite|
        sprite.type = :circle
        sprite.center = contact.contact_loc
        sprite.radius = 10
        sprite.use_transform = false
        sprite.fill = true
        sprite.color = Canvas::Colors.yellow
        sprite.z = 1
      end

      @scene.add_effect(Canvas::Fade.new(sprite, 10))
    end
  end

  # Parts

  def poly
    verts = [V.new(0, 0), V.new(100, 0), V.new(100, 100), V.new(50, 150), V.new(0, 100)]

    Shape::Poly.new do |rect|
      rect.name = "Poly"
      rect.body = @body
      rect.mass = 10
      rect.set_verts(verts)
      rect.color = Canvas::Colors.light_grey
    end
  end
end