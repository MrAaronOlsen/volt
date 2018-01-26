require "./spec/spec_helper.rb"

RSpec.describe Hull do

  describe "Initialization" do

    before do
      @hull = TestBody.new.hull
    end

    it "finds left vert" do
      left_vert = @hull.left_vert

      assert(left_vert == V.new)
    end

  end
end