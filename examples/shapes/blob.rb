class Blob
  attr_reader :body, :parts

  def initialize(pos)
    @body = new_blob(pos)
    build
  end

  def new_blob(pos)
    Body.new do |b|
			b.pos = pos
			b.mass = 40
			b.moment = 400
		end
  end

  def build
    @parts = [tail, neck, head]
    @body.init
    @body.recenter
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

  def tail
    Shape::Circle.new do |circ|
      circ.name = "Blob Tail"
      circ.body = @body
      circ.mass = 3
      circ.set_verts(V.new(0, 0), 75)
      circ.color = Canvas::Colors.light_grey
    end
  end

  def neck
    Shape::Circle.new do |circ|
      circ.name = "Blob Neck"
      circ.body = @body
      circ.mass = 1
      circ.set_verts(V.new(0, 100), 50)
      circ.color = Canvas::Colors.light_grey
    end
  end

  def head
    Shape::Circle.new do |circ|
      circ.name = "Blob Head"
      circ.body = @body
      circ.mass = 3
      circ.set_verts(V.new(0, 200), 75)
      circ.color = Canvas::Colors.light_grey
    end
  end
end