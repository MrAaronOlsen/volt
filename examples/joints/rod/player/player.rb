class Player
  attr_reader :body, :parts, :scene

  def initialize(pos, angle, scene)
    @body = new_player(pos)
    @scene = scene
    build(angle)
  end

  def new_player(pos)
    Body.new do |b|
			b.pos = pos
			b.mass = 300
			b.moment = 3000
		end
  end

  def build(angle)
    @parts = [player]

    @body.init
    @body.recenter
    @body.rotate(angle)

    add_callbacks
  end

  def go
    @body.add_impulse(V.from_angle(@body.angle) * 1000)
  end

  def stop
    @body.add_force(V.from_angle(@body.angle) * -2000) if @body.vel.mag > 0
  end

  def right
    @body.add_rotation(3)
  end

  def left
    @body.add_rotation(-3)
  end

  def freeze
    @body.set_vel(V.new(0, 0))
    @body.set_a_vel(0)
  end

  def add_callbacks
    # @body.add_callback_block(:pre) do |body, contact|
    #   Canvas::Contact.sketch(contact, @scene)
    # end
  end

  # Parts

  def player
    verts = [V.new(0, 0), V.new(100, 0), V.new(100, 100), V.new(50, 150), V.new(0, 100)]

    Shape::Poly.new do |rect|
      rect.name = "Poly"
      rect.body = @body
      rect.mass = 10
      rect.set_verts(verts)
      rect.color = Canvas::Colors.light_grey
    end
  end

  # def player
  #   Shape::Line.new do |line|
  #     line.body = @body
  #     line.name = "line"
  #     line.mass = 1
  #     line.set_verts(V.new(0, 0), V.new(200, 0))
  #     line.color = Canvas::Colors.light_grey
  #   end
  # end
end