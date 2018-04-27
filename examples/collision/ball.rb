class Ball
  attr_reader :body, :parts

  def initialize(pos)
    @body = new_ball(pos)
    build
  end

  def new_ball(pos)
    Body.new do |b|
			b.pos = pos
			b.damp = 0.99
			b.mass = 5
			b.moment = 3000
		end
  end

  def build
    @parts = [circle, line]

    @body.rotate(90)
  end

  def go
    @body.add_impulse(V.from_angle(@body.angle) * 100)
  end

  def stop
    @body.add_force(V.from_angle(@body.angle) * -100) if @body.vel.mag > 0
  end

  def right
    @body.add_rotation(10)
  end

  def left
    @body.add_rotation(-10)
  end

  # Parts

  def circle
    Shape::Circle.new do |circ|
      circ.body = @body
      circ.name = "Player Body"
      circ.mass = 3
      circ.set_verts(V.new(0, 0), 100)
      circ.color = Canvas::Color.orange
    end
  end

  def line
    Shape::Line.new do |line|
      line.body = @body
      line.static = true
      line.mass = 0
      line.set_verts(V.new(0, 0), V.new(0, -100))
      line.color = Canvas::Color.blue
    end
  end
end