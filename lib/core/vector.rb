module Volt
  class Vector
    attr_reader :x, :y
    attr_reader :name

    def initialize(x = 0.0, y = 0.0)
      @x = x.to_f
      @y = y.to_f
    end

    def with_name(name)
      @name = name
      self
    end

    # Handy constructors
    class << self

      # Makes a unit vector based on the given angle (in degrees)
      def from_angle(degree)
        theta = radian(degree)

        Vector.new(Math.cos(theta), Math.sin(theta))
      end

      # Makes a vector and rotates it by the given angle (in degrees)
      def with_rotation(x, y, degree)
        vect = Vector.new(x, y)
        vect.rotate(degree)

        vect
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
      Vector.new(@x / value, @y / value) unless value.zero?
    end

    def scale(value)
      self.tap { @x *= value; @y *= value }
    end

    def cheap_mag
      @x * @x + @y * @y
    end

    def mag
      Math.sqrt(@x * @x + @y * @y)
    end

    def distance_to(vect)
      (self - vect).mag
    end

    def normalize
      m = mag
      self.tap { unless m.zero? then @x/=m; @y/=m end }
    end

    def unit
      vector = copy
      vector.normalize
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

    def projection_onto(vect)
      d = vect.dot(vect)

      if 0 < d
        dp = self.dot(vect)
        vect * (dp / d)
      else
        vect
      end
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

      self
  	end

    def to_s
      unless @name.nil?
        "#{@name} | X: #{@x}, Y: #{@y}"
      else
        "X: #{@x}, Y: #{@y}"
      end
    end
  end

  # Volt level helpers

  # Returns 1 if b is to the right of a in reference to o
  def determinant(o, a, b)
    d = (a.y - o.y) * (b.x - a.x) - (b.y - a.y) * (a.x - o.x)
    return 0 if d.zero?

    d <=> 0
  end

  def radian(degree) #convert a degree to a radian
     degree*(Math::PI/180)
  end

  Vect = Vector
  V = Vector
end