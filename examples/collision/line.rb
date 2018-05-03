class Line
  attr_reader :body, :parts

  def initialize(pos, length, angle)
    @body = new_line(pos)
    build(length, angle)
  end

  def new_line(pos)
    Body.new do |b|
			b.pos = pos
			b.damp = 0
			b.mass = 0
			b.moment = 0
		end
  end

  def build(length, angle)
    @parts = [line(length)]

    @body.rotate(angle)
  end

  # Parts

  def line(length)
    Shape::Line.new do |line|
      line.body = @body
      line.mass = 1
      line.set_verts(V.new(0, 0), V.new(length, 0))
      line.color = Canvas::Color.light_grey
    end
  end
end