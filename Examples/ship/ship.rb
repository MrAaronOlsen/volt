class Ship
  attr_reader :body, :parts

  def initialize(pos)
    @body = new_ship(pos)
    build
  end

  def new_ship(pos)
    Body.new do |b|
			b.pos = pos
			b.damp = 0.998
			b.mass = 10
			b.moment = 1000
		end
  end

  def build
    @parts = [ nose, fusilage, l_wing,
      r_wing, cockpit, l_wing_tip,
      r_wing_tip, l_engine, r_engine ]

    @body.rotate(90)
    @body.recenter
  end

  def go
    @body.add_impulse(V.from_angle(@body.angle) * 100)
  end

  def stop
    @body.add_force(V.from_angle(@body.angle) * -100) if @body.vel.mag > 0
  end

  def right
    @body.add_rotation(4)
  end

  def left
    @body.add_rotation(-4)
  end

  # Parts

  def nose
    Shape::Poly.new do |poly|
      poly.body = @body
      poly.mass = 3
      poly.set_verts([V.new(50, 0), V.new(60, 0), V.new(70, 20), V.new(40, 20)])
      poly.color = Canvas::Colors.orange
    end
  end

  def cockpit
    Shape::Rect.new do |rect|
      rect.body = @body
      rect.mass = 1
      rect.set_verts(30, 20, V.new(40, 20))
      rect.color = Canvas::Colors.blue
    end
  end

  def fusilage
    Shape::Rect.new do |rect|
      rect.body = @body
      rect.mass = 4
      rect.set_verts(30, 60, V.new(40, 30))
      rect.color = Canvas::Colors.orange
    end
  end

  def l_wing
    wing([V.new(10, 50), V.new(40, 40), V.new(40, 70), V.new(20, 70)])
  end

  def r_wing()
    wing([V.new(70, 40), V.new(100, 50), V.new(90, 70), V.new(70, 70)])
  end

  def wing(verts)
    Shape::Poly.new do |poly|
      poly.body = @body
      poly.mass = 1
      poly.set_verts(verts)
      poly.color = Canvas::Colors.grey
    end
  end

  def l_wing_tip
    wing_tip(V.new(10, 50), V.new(20, 70), V.new(0, 80))
  end

  def r_wing_tip
    wing_tip(V.new(100, 50), V.new(110, 80), V.new(90, 70))
  end

  def wing_tip(v1, v2, v3)
    Shape::Tri.new do |tri|
      tri.body = @body
      tri.mass = 0.5
      tri.set_verts(v1, v2, v3)
      tri.color = Canvas::Colors.grey
    end
  end

  def l_engine
    engine([V.new(40, 90), V.new(50, 90), V.new(52.5, 100), V.new(37.5, 100)])
  end

  def r_engine
    engine([V.new(60, 90), V.new(70, 90), V.new(72.5, 100), V.new(57.5, 100)])
  end

  def engine(verts)
    Shape::Poly.new do |poly|
      poly.body = @body
      poly.mass = 0.5
      poly.set_verts(verts)
      poly.color = Canvas::Colors.red
    end
  end
end