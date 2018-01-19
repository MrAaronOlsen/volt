
class Ship
  attr_reader :body, :parts
  attr_reader :grey_parts, :blue_parts, :red_parts

  def initialize
    @body = new_ship
    make_parts

    @parts.each { |part| part.set_body(@body) }
    @body.rotate(90)
    @body.recenter
  end

  def new_ship
    Body.new do |b|
			b.pos = V.new(600, 600)
			b.damp = 0.98
			b.mass = 10
			b.moment = 3000
		end
  end

  def draw
    @grey_parts.each { |part| draw_part(part, 0xff_aaaaaa) }
    @blue_parts.each { |part| draw_part(part, 0xff_0000ff) }
    @red_parts.each { |part| draw_part(part, 0xff_ff0000) }

    Draw.circle_empty(@body.cog, 10, 0xff_ff0000)
    Draw.circle_full(@body.pos, 5, 0xff_ffffff)
  end

  def draw_part(part, color)
    Draw.circle_full(part.world_centroid, 2, 0xff_ffffff, 2)

    Draw.tri(part.world_verts, color, 1) if part.type == "tri"
    Draw.rect(part.world_verts, color, 1) if part.type == "box"
    Draw.poly(part.world_verts, part.world_centroid, color, 1) if part.type == "poly"
  end

  def make_parts
    @grey_parts = [nose, fusilage, l_wing, r_wing]
    @blue_parts = [cockpit]
    @red_parts = [l_wing_tip, r_wing_tip, l_engine, r_engine]

    @parts = [@grey_parts, @blue_parts, @red_parts].flatten
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

  def nose
    Shape::Poly.new(3, V.new(50, 0), V.new(60, 0), V.new(70, 20), V.new(40, 20))
  end

  def cockpit
    Shape::Box.new(30, 20, V.new(40, 20), 1)
  end

  def fusilage
    Shape::Box.new(30, 60, V.new(40, 30), 4)
  end

  def l_wing
    Shape::Poly.new(1, V.new(10, 50), V.new(40, 40), V.new(40, 70), V.new(20, 70))
  end

  def r_wing
    Shape::Poly.new(1, V.new(70, 40), V.new(100, 50), V.new(90, 70), V.new(70, 70))
  end

  def l_wing_tip
    Shape::Tri.new(0.5, V.new(10, 50), V.new(20, 70), V.new(0, 80))
  end

  def r_wing_tip
    Shape::Tri.new(0.5, V.new(100, 50), V.new(110, 80), V.new(90, 70))
  end

  def l_engine
    Shape::Poly.new(0.5, V.new(40, 90), V.new(50, 90), V.new(52.5, 100), V.new(37.5, 100))
  end

  def r_engine
    Shape::Poly.new(0.5, V.new(60, 90), V.new(70, 90), V.new(72.5, 100), V.new(57.5, 100))
  end
end