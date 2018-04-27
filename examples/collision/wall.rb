class Wall
  attr_reader :body, :parts

  def initialize(pos)
    @body = new_wall(pos)
    build
  end

  def new_wall(pos)
    Body.new do |b|
			b.pos = pos
			b.damp = 0
			b.mass = 0
			b.moment = 0
		end
  end

  def build
    @parts = [line]

    @body.init
  end

  # Parts

  def line
    Shape::Line.new do |line|
      line.body = @body
      line.mass = 1
      line.set_verts(V.new(0, 0), V.new(0, 1000))
      line.color = Canvas::Color.grey
    end
  end
end