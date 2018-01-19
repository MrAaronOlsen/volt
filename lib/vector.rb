module Volt
  class Vector
    attr_reader :x, :y

    def initialize(x = 0.0, y = 0.0)
      @x = x.to_f
      @y = y.to_f
    end

    # Handy constructors
    class << self

      # Makes a unit vector based on the given angle (in degrees)
      def from_angle(degree)
        theta = radian(degree)

        Vector.new(Math.cos(theta), Math.sin(theta))
      end
    end

    def zero!
      self.tap { scale(0) }
    end

    def copy
      Vector.new(@x, @y)
    end

    def +(vect)
      Vector.new(@x + vect.x, @y + vect.y)
    end

    def add(vect)
      self.tap { @x += vect.x ; @y += vect.y }
    end

    def -(vect)
      Vector.new(@x - vect.x, @y - vect.y)
    end

    def sub(vect)
      self.tap { @x -= vect.x; @y -= vect.y }
    end

    def *(value)
      Vector.new(@x * value, @y * value)
    end

    def /(value)
      Vector.new(@x / value, @y / value)
    end

    def scale(value)
      self.tap { @x *= value; @y *= value }
    end

    def mag
      Math.sqrt(@x * @x + @y * @y)
    end

    def normalize
      m = magnitude
      unless m.zero? then @x/=m; @y/=m end
    end

    def dot(vect)
      ( @x * vect.x ) + ( @y * vect.y )
    end

    def cross(vect)
      ( @x * vect.y ) - ( @y * vect.x )
    end

    def ==(vect)
      @x == vect.x && @y == vect.y
    end

    # matrix related
    def transform(matrix)
      vect = matrix.transform_vert(self)
      @x, @y = vect.x, vect.y
    end

    # rotation
    def rotate(degree) #rotate self by some degree
      theta = radian(degree)
  		x = @x

      @x = x*Math.cos(theta) - @y*Math.sin(theta)
  	  @y = x*Math.sin(theta) + @y*Math.cos(theta)
  	end

    def print
      puts "X: #{@x}, Y:#{@y}"
    end
  end

  # Volt level helpers

  def radian(degree) #convert a degree to a radian
     degree*(Math::PI/180)
  end

  Vect = Vector
  V = Vector
end