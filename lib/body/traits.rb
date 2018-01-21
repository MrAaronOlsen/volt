module Volt
  class Traits
    # position
    attr_reader :pos, :trans
    # linear
    attr_reader :acc, :vel, :mass, :i_mass
    # angular
    attr_reader :angle, :a_vel, :moment, :i_moment
    # forces
    attr_reader :damp, :forces, :torque
    # shapes
    attr_reader :shapes, :cog

    def initialize()
      @pos, @trans = V.new, Mat.new_identity
      @acc, @vel, @mass = V.new, V.new, 0.0
      @angle, @a_vel, @moment = 0.0, 0.0, 0.0
      @damp, @forces, @torque = 1.0, V.new, 0.0
      @shapes, @cog = [], V.new
    end

  # Attribute Getters / Setters

    def mass=(mass)
      @mass = mass
      set_i_mass(@mass)
    end

    def moment=(moment)
      @moment = moment
      set_i_moment(@moment)
    end

    def damp=(damp)
      @damp = damp
    end

    def pos=(pos)
      @pos = pos
    end

    def cog
      @trans.transform_vert(@cog)
    end

  # Transform Functions

    def build
      transform(Mat.new_identity)
    end

    def offset(vect)
      transform(Mat.new_translate(vect))
    end

    def recenter
      transform(Mat.new_translate(@pos - cog))
    end

    def rotate(angle)
      transform(Mat.new_rotate(angle))
    end

    def add_shape(shape)
      @shapes << shape

      set_transform
      set_cog
    end

    private

    def transform(matrix)
      @shapes.each do |shape|
        shape.transform(matrix)
      end

      set_cog
    end

    def set_cog
      bot = 0

      @cog = @shapes.reduce(V.new) do |top, shape|
        bot += shape.mass
        top + shape.centroid * shape.mass
      end / bot
    end

    def set_transform
      @trans = Mat.new_transform(@pos, @angle)
    end

    def set_i_mass(mass)
      mass > 0.0 ? @i_mass = 1.0 / mass : @i_mass = 0.0
    end

    def set_i_moment(moment)
      moment > 0.0 ? @i_moment = 1.0 / moment : @i_moment = 0.0
    end
  end
end