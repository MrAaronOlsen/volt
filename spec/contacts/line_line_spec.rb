require_relative "test_shapes.rb"

RSpec.describe Contact::LineCircle do

  describe '#query' do

    it 'accepts a simple contact from the right' do
      line1 = TestShapes.line(V.new(2, 5), [V.new(0, -3), V.new(0, 3)], "Line1")
      line2 = TestShapes.line(V.new(4, 3), [V.new(-3, 0), V.new(3, 0)], "Line1")

      handler = Contact::LineLine.new(line1, line2)
      collided = handler.query

      expect(collided).to be_truthy
      contact = handler.manifold

      pen = contact.penetration
      norm = contact.contact_normal
      loc = contact.contact_loc

      expect(pen).to equal(1.0)
      expect(norm == V.new(-1.0, 0.0)).to be_truthy
      expect(loc == V.new(2.0, 3.0)).to be_truthy
    end

    it 'accepts a simple contact from the left' do
      line1 = TestShapes.line(V.new(2, 5), [V.new(0, 3), V.new(0, -3)], "Line1")
      line2 = TestShapes.line(V.new(4, 3), [V.new(-3, 0), V.new(3, 0)], "Line1")

      handler = Contact::LineLine.new(line1, line2)
      collided = handler.query

      expect(collided).to be_truthy
      contact = handler.manifold

      pen = contact.penetration
      norm = contact.contact_normal
      loc = contact.contact_loc

      expect(pen).to equal(1.0)
      expect(norm == V.new(-1.0, 0.0)).to be_truthy
      expect(loc == V.new(2.0, 3.0)).to be_truthy
    end

    it 'refuses a close point point contact' do
      line1 = TestShapes.line(V.new(2, 5), [V.new(0, 3), V.new(0, -3)], "Line1")
      line2 = TestShapes.line(V.new(5, 2), [V.new(-3, 0), V.new(3, 0)], "Line1")

      handler = Contact::LineLine.new(line1, line2)
      collided = handler.query

      expect(collided).to be_falsy
    end

    it 'refuses a close point face contact' do
      line1 = TestShapes.line(V.new(2, 5), [V.new(0, 3), V.new(0, -3)], "Line1")
      line2 = TestShapes.line(V.new(5, 3), [V.new(-3, 0), V.new(3, 0)], "Line1")

      handler = Contact::LineLine.new(line1, line2)
      collided = handler.query

      expect(collided).to be_falsy
    end

  end
end