module Volt
  class Body < BodyTraits

    def initialize
      super

      yield self
    end

    def add_shape(shape)
      @shapes << shape

      set_transform
    end

    def set_transform
      @trans = Mat.new_transform(@pos, @angle)
    end

    def recenter
      transform(Mat.new_translate(@pos - cog))
    end

    def rotate(angle)
      transform(Mat.new_rotate(angle))
    end

    def transform(matrix)
      @shapes.each do |shape|
        shape.transform(matrix)
      end
    end

# Life cycle functions

    def update(dt)
      return if @mass <= 0

      @vel = (@vel * @damp) + (@forces * @i_mass) * dt
      @a_vel = (@a_vel * @damp) + (@torque * @i_moment) * dt

      @forces.zero!
      @torque = 0.0

      @pos += @vel * dt
      @angle += @a_vel * dt

      set_transform
    end

    def add_force(force)
      @forces.add(force)
    end

    def add_force_at(force, vert)
      @forces.add(force)

      r = point - @trans.transform_vert(cog)
      @torque += r.cross(force)
    end

    def add_impulse(impulse)
      @vel = @vel + (impulse * @i_mass)
    end

    def add_impulse_at(impulse, point)
      @vel = @vel + (impulse * @i_mass)

      r = point - @trans.transform_vert(cog)
      @a_vel += r.cross(impulse) * @i_moment
    end

    def add_rotation(vel)
      @a_vel += vel
    end
  end
end