class Line
  attr_reader :body, :parts

  def initialize(pos, length, angle)
    @body = new_line(pos)
    build(length, angle)
  end

  def new_line(pos)
    Body.new do |b|
			b.pos = pos
			b.damp = 0.98
			b.mass = 300
			b.moment = 30
		end
  end

  def build(length, angle)
    @parts = [line(length)]

    @body.init
    @body.rotate(angle)
    @body.recenter
  end

  # Parts

  def line(length)
    Shape::Line.new do |line|
      line.body = @body
      line.name = "line"
      line.mass = 1
      line.set_verts(V.new(0, 0), V.new(length, 0))
      line.color = Canvas::Colors.light_grey
    end
  end
end