class Box
  attr_reader :body, :parts

  def initialize(pos)
    @body = new_box(pos)
    build
  end

  def new_box(pos)
    Body.new do |b|
			b.pos = pos
			b.mass = 10
			b.moment = 500
		end
  end

  def build
    @parts = [box]
    @body.init
  end

  # Parts

  def box
    Shape::Rect.new do |rect|
      rect.name = "Box"
      rect.body = @body
      rect.mass = 10
      rect.set_verts(100, 100, V.new(0, 0))
      rect.color = Canvas::Color.light_grey
    end
  end
end