RSpec.describe Body do

  describe "Initialization" do

    it "defaults attributes" do
      body = Body.new

      expect(body).to be_a(Body)
      expect(body.pos == V.new).to be_truthy
      expect(body.vel == V.new).to be_truthy
      expect(body.acc == V.new).to be_truthy
      expect(body.mass).to eq(0.0)
      expect(body.damp).to eq(1.0)
    end

    it "can be configured" do
      body = Body.new do |b|
        b.config(
          vel: V.new(0, 10),
          pos: V.new(600, 0),
          acc: V.new(0.1, 0),
          mass: 10, damp: 0.98
        )
      end

      expect(body.pos == Vect.new(600, 0)).to be_truthy
      expect(body.vel == Vect.new(0, 10)).to be_truthy
      expect(body.acc == Vect.new(0.1, 0)).to be_truthy
      expect(body.mass).to eq(10.0)
      expect(body.damp).to eq(0.98)
    end
  end
end