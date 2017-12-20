module Volt
  class Vector
    attr_reader :x, :y

    def initialize(x = 0.0, y = 0.0)
      @x = x.to_f
      @y = y.to_f
    end

    def +(vect)
      Vector.new(@x + vect.x, @y + vect.y)
    end

    def add(vect)
      @x += vect.x
      @y += vect.y
    end

    def -(vect)
      Vector.new(@x - vect.x, @y - vect.y)
    end

    def sub(vect)
      @x -= vect.x
      @y -= vect.y
    end

    def *(value)
      Vector.new(@x * value, @y * value)
    end

    def scale!(value)
      @x *= value
      @y *= value
    end

    def magnitude
      Math.sqrt(@x * @x + @y * @y)
    end

    def normalize!
      m = magnitude
      unless m.zero? then @x/=m; @y/=m end
    end

    def dot(vect)
      @x * vect.x + @y * vect.y
    end

    def cross(vect)
      @x * vect.y - @y * vect.x;
    end

    def zero
      @x, @y = 0.0, 0.0
    end
  end
end