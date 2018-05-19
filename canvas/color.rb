module Canvas
  class Color
    attr_reader :a, :r, :g, :b
    attr_reader :color

    def initialize(a, r, g, b)
      @a, @r, @g, @b = a, r, g, b

      @color = Gosu::Color.new(@a, @r, @g, @b)
    end

    def fade(n)
      @a += n
      @color = Gosu::Color.new(@a, @r, @g, @b)
    end

    def get
      @color
    end
  end
end