class Box
  attr_reader :body, :parts

  def initialize(pos)
    @body = new_box(pos)
    build
  end

  def new_box(pos)
    Body.new do |b|
			b.pos = pos
			b.mass = 30
			b.moment = 300
		end
  end

  def build
    @parts = [box, line]
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
    @body.add_rotation(2)
  end

  def left
    @body.add_rotation(-2)
  end

  def freeze
    @body.set_vel(V.new(0, 0))
    @body.set_a_vel(0)
  end

  # Parts

  def box
    Shape::Rect.new do |rect|
      rect.name = "Box"
      rect.body = @body
      rect.mass = 10
      rect.set_verts(200, 200, V.new(0, 0))
      rect.color = Canvas::Colors.light_grey
    end
  end

  def line
    Shape::Line.new do |line|
      line.body = @body
      line.static = true
      line.set_verts(V.new(100, 100), V.new(200, 100))
      line.color = Canvas::Colors.green
    end
  end
end