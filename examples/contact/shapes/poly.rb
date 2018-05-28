class Poly
  attr_reader :body, :parts

  def initialize(pos, angle)
    @body = new_box(pos)
    build(angle)
  end

  def new_box(pos)
    Body.new do |b|
			b.pos = pos
			b.mass = 3
			b.moment = 300
		end
  end

  def build(angle)
    @parts = [poly]

    @body.init
    @body.recenter
    @body.rotate(angle)
  end

  # Parts

  def poly
    verts = [V.new(0, 0), V.new(100, 0), V.new(100, 100), V.new(50, 150), V.new(0, 100)]

    Shape::Poly.new do |rect|
      rect.name = "Poly"
      rect.body = @body
      rect.mass = 10
      rect.set_verts(verts)
      rect.color = Canvas::Colors.light_grey
    end
  end
end