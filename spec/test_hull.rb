require './volt'

class TestHull
  attr_reader :body, :hull

  def initialize
    @body = Body.new

    @body.add_shape(box1)
    @body.add_shape(box2)
    @body.add_shape(box3)
    @body.add_shape(poly1)
    @body.add_shape(poly2)
  end

  def box1
    Shape::Box.new(2, 2, V.new, 0)
  end

  def box2
    Shape::Box.new(4, 1, V.new(4, 2), 0)
  end

  def box3
    Shape::Box.new(1, 4, V.new(2, 4), 0)
  end

  def poly1
    Shape::Poly.new(0, V.new(2, 1), V.new(4, 1), V.new(4, 4), V.new(2, 2))
  end

  def poly2
    Shape::Poly.new(0, V.new(2, 2), V.new(4, 4), V.new(1, 4), V.new(1, 2))
  end
end