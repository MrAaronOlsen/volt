class Blob
  attr_reader :body, :parts

  def initialize(pos)
    @body = new_ball(pos)
    build
  end

  def new_ball(pos)
    Body.new do |b|
			b.pos = pos
			b.damp = 0.99
			b.mass = 20
			b.moment = 1000
		end
  end

  def build
    @parts = [main_body, neck, head]
    @body.rotate(-90)
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

  def main_body
    Shape::Circle.new do |circ|
      circ.name = "Blob Body"
      circ.body = @body
      circ.mass = 3
      circ.set_verts(V.new(0, 0), 100)
      circ.color = Canvas::Color.orange
    end
  end

  def neck
    Shape::Circle.new do |circ|
      circ.name = "Blob Neck"
      circ.body = @body
      circ.mass = 1
      circ.set_verts(V.new(0, 100), 50)
      circ.color = Canvas::Color.white
    end
  end

  def head
    Shape::Circle.new do |circ|
      circ.name = "Blob Head"
      circ.body = @body
      circ.mass = 2
      circ.set_verts(V.new(0, 200), 75)
      circ.color = Canvas::Color.blue
    end
  end
end