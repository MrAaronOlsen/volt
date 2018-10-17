module Volt
  class Traits
    # position
    attr_reader :pos, :trans
    # linear
    attr_reader :acc, :vel, :mass, :i_mass
    # angular
    attr_reader :angle, :a_vel, :moment, :i_moment
    # forces
    attr_reader :damp, :restitution, :forces, :torque
    # friction
    attr_reader :static_friction, :dynamic_friction
    # shapes
    attr_reader :shapes, :cog
    # collision shapes
    attr_reader :hull, :bounding

    def initialize()
      @pos, @origin_angle, @trans = V.new, 0.0, Mat.new_identity
      @acc, @vel, @mass = V.new, V.new, 0.0
      @angle, @a_vel, @moment = 0.0, 0.0, 0.0
      @damp, @restitution, @forces, @torque = 0.999, 1.0, V.new, 0.0
      @static_friction, @dynamic_friction = 1.0, 1.0
      @shapes, @cog = [], V.new
      @bounding = AABB.new(self)
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

    def vel=(vel)
      @vel = vel
    end

    def all_verts
      @shapes.reduce([]) do |all, shape|
        all + shape.verts
      end
    end

  # Transform Shape Functions

    def init
      transform(Mat.new_identity)
      build
    end

    def offset(vect)
      transform(Mat.new_translate(vect))
      build
    end

    def recenter
      transform(Mat.new_translate(@pos - trans.transform_vert(cog)))
      build
    end

    def rotate(angle)
      transform(Mat.new_rotate(angle))
      build
    end

    def scale(x, y)
      transform(Mat.new_scale(x, y))
      build
    end

    def add_shape(shape)
      @shapes << shape
    end

    def build
      set_transform
      set_cog
      set_hull
    end

    private

    def transform(matrix)
      @shapes.each do |shape|
        shape.transform(matrix)
      end

      set_cog
    end

    def set_transform
      @trans = Mat.new_transform(@pos, @angle)
    end

    def set_cog
      bot = 0

      @cog = @shapes.reduce(V.new) do |top, shape|
        bot += shape.mass
        top + shape.centroid * shape.mass
      end / bot
    end

    def set_hull
      @hull = Hull.new(all_verts)
    end

    def set_i_mass(mass)
      mass > 0.0 ? @i_mass = 1.0 / mass : @i_mass = 0.0
    end

    def set_i_moment(moment)
      moment > 0.0 ? @i_moment = 1.0 / moment : @i_moment = 0.0
    end
  end
end