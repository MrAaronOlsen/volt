require_relative "test_shapes.rb"

RSpec.describe Collision::LineCircle do

  describe '#query' do

    it 'accepts a line endpoint to circle contact' do
      line = TestShapes.line(V.new(4, 8), [V.new(0, -3), V.new(0, 3)], "Line")
      circle = TestShapes.circle(V.new(4, 4), 2, "Circle")

      handler = Collision::LineCircle.new(line, circle)
      collided = handler.query

      expect(collided).to be_truthy

      contact = handler.get_contact

      pen = contact.penetration
      norm = contact.contact_normal
      loc = contact.contact_loc

      expect(pen).to equal(1.0)
      expect(norm == V.new(0.0, 1.0)).to be_truthy
      expect(loc == V.new(4.0, 6.0)).to be_truthy
    end

    it 'accepts a line face to circle contact' do
      line = TestShapes.line(V.new(5, 5), [V.new(-2, 2), V.new(2, -2)], "Line")
      circle = TestShapes.circle(V.new(4, 4), 2, "Circle")

      handler = Collision::LineCircle.new(line, circle)
      collided = handler.query

      expect(collided).to be_truthy

      contact = handler.get_contact

      pen = contact.penetration
      norm = contact.contact_normal
      loc = contact.contact_loc

      expect(pen).to be_within(0.001).of(0.585)

      expect(norm.x).to be_within(0.001).of(0.707)
      expect(norm.y).to be_within(0.001).of(0.707)

      expect(loc.x).to be_within(0.001).of(5.414)
      expect(loc.y).to be_within(0.001).of(5.414)
    end
  end
end