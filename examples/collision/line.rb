class Line
  attr_reader :body, :parts

  def initialize(pos, length)
    @body = new_line(pos)
    build(length)
  end

  def new_line(pos)
    Body.new do |b|
			b.pos = pos
			b.damp = 0.998
			b.mass = 5
			b.moment = 500
		end
  end

  def build(length)
    @parts = [line(length)]

    @body.init
    @body.recenter
  end

  # Parts

  def line(length)
    Shape::Line.new do |line|
      line.body = @body
      line.name = "line"
      line.mass = 1
      line.set_verts(V.new(0, 0), V.new(length, 0))
      line.color = Canvas::Color.light_grey
    end
  end
end