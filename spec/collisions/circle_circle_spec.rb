require_relative "test_shapes.rb"

RSpec.describe Collision::CircleCircle do

  describe '#query' do

    it 'accepts a simple contact' do
      circle_b = TestShapes.circle(V.new(5, 6), 3, "Circle A")
      circle_a = TestShapes.circle(V.new(9, 6), 2, "Circle B")

      handler = Collision::CircleCircle.new(circle_a, circle_b)
      expect(handler.query).to be_truthy

      collision = handler.get_contact

      pen = collision.penetration
      norm = collision.contact_normal
      loc = collision.contact_loc

      expect(pen).to equal(1.0)
      expect(norm == V.new(1.0, 0.0)).to be_truthy
      expect(loc == V.new(7.4, 6.0)).to be_truthy
    end

    it 'will produce the same results if shapes are reversed' do
      circle_a = TestShapes.circle(V.new(5, 6), 3, "Circle A")
      circle_b = TestShapes.circle(V.new(9, 6), 2, "Circle B")

      handler = Collision::CircleCircle.new(circle_a, circle_b)
      expect(handler.query).to be_truthy

      collision = handler.get_contact

      pen = collision.penetration
      norm = collision.contact_normal
      loc = collision.contact_loc

      expect(pen).to equal(1.0)
      expect(norm == V.new(-1.0, 0.0)).to be_truthy
      expect(loc == V.new(7.4, 6.0)).to be_truthy
    end

    it 'refuses a close contact' do
      circle_a = TestShapes.circle(V.new(5, 6), 3, "Circle A")
      circle_b = TestShapes.circle(V.new(10, 6), 2, "Circle B")

      handler = Collision::CircleCircle.new(circle_a, circle_b)
      expect(handler.query).to be_falsy
    end
  end
end