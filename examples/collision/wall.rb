class Wall
  attr_reader :body, :parts

  def initialize(pos, angle)
    @body = new_wall(pos)
    build(angle)
  end

  def new_wall(pos)
    Body.new do |b|
			b.pos = pos
			b.damp = 0
			b.mass = 0
			b.moment = 0
		end
  end

  def build(angle)
    @parts = [line]

    @body.rotate(angle)
  end

  # Parts

  def line
    Shape::Line.new do |line|
      line.body = @body
      line.mass = 1
      line.set_verts(V.new(0, 0), V.new(0, 1100))
      line.color = Canvas::Colors.light_grey
    end
  end
end