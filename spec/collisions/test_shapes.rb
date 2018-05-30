class TestShapes

  class << self

    def new_body(pos)
      Body.new do |b|
        b.pos = pos
        b.mass = 20
        b.moment = 200
      end
    end

    def circle(pos, radius, name)
      body = new_body(pos)

      shape = Shape::Circle.new do |circ|
        circ.body = body
        circ.name = name
        circ.mass = 3
        circ.set_verts(V.new(0, 0), radius)
      end

      body.init
      shape
    end

    def line(pos, verts, name)
      body = new_body(pos)

      shape = Shape::Line.new do |line|
        line.body = body
        line.name = name
        line.mass = 3
        line.set_verts(verts[0], verts[1])
      end

      body.init
      shape
    end
  end
end