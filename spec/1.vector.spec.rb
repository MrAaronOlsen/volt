RSpec.describe Vector do

  describe 'Initialization' do
    it 'defaults x and y to 0.0' do
      vect = Vector.new

      expect(vect.x).to equal(0.0)
      expect(vect.y).to equal(0.0)
    end

    it 'converts all ints to floats' do
      vect = Vector.new(1, 2)

      expect(vect.x).to equal(1.0)
      expect(vect.y).to equal(2.0)
    end
  end

  describe 'Vector Math' do
    before do
      @vect1 = Vector.new(3, 4)
      @vect2 = Vector.new(4, 8)
    end

    describe 'Returning functions' do
      it 'can add two vectors' do
        vect3 = @vect1 + @vect2

        expect(vect3.x).to eq(7.0)
        expect(vect3.y).to eq(12.0)
      end

      it 'can subtract two vectors' do
        vect3 = @vect1 - @vect2

        expect(vect3.x).to eq(-1.0)
        expect(vect3.y).to eq(-4.0)
      end

      it 'can multiply two vectors' do
        vect3 = @vect1 * 2

        expect(vect3.x).to eq(6.0)
        expect(vect3.y).to eq(8.0)
      end

      it 'can do compound math' do
        vect3 = (@vect1 + @vect2) * 10

        expect(vect3.x).to eq(70)
        expect(vect3.y).to eq(120)
      end

      it 'can calculate the dot product' do
        dot = @vect1.dot(@vect2)

        expect(dot).to eq(44.0)
      end

      it 'can calculate the analog cross product' do
        cross = @vect1.cross(@vect2)

        expect(cross).to eq(8.0)
      end

      it 'can calculate its magnitude' do
        mag = @vect1.magnitude

        expect(mag).to eq(5.0)
      end
    end

    describe 'Mutating functions' do
      before do
        @vect1 = Vector.new(3, 4)
      end

      it 'can add to itself' do
        @vect1.add(Vector.new(5, 6))

        expect(@vect1.x).to eq(8.0)
        expect(@vect1.y).to eq(10.0)
      end

      it 'can subtract from itself' do
        @vect1.sub(Vector.new(5, 6))

        expect(@vect1.x).to eq(-2.0)
        expect(@vect1.y).to eq(-2.0)
      end

      it 'can scale by a value' do
        @vect1.scale(2)

        expect(@vect1.x).to eq(6.0)
        expect(@vect1.y).to eq(8.0)
      end

      it 'can do compound math' do
        vect2 = Vector.new(4, 8)
        @vect1.add(vect2).scale(10)

        expect(@vect1.x).to eq(70)
        expect(@vect1.y).to eq(120)
      end

      it 'can normalize itself' do
        @vect1.normalize

        expect(@vect1.x).to eq(0.6)
        expect(@vect1.y).to eq(0.8)
      end

      it 'can zero itself' do
        @vect1.zero!

        expect(@vect1.x).to eq(0.0)
        expect(@vect1.y).to eq(0.0)
      end
    end
  end

end