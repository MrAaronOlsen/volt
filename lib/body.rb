module Volt
  class Body < BodyBuilder

    def initialize
      super

      yield self
    end

    def add_shape(shape)
      @shapes << shape

      set_transform
    end

    def cog
      bot = 0

      top = @shapes.reduce(V.new) do |top, shape|
        bot += shape.mass
        top + shape.world_centroid * shape.mass
      end

      top / bot
    end

    def set_transform
      @transform = Mat23.new_transform(@pos, @angle)
    end

# Life cycle functions

    def update(dt)
      return if @mass <= 0

      @vel = (@vel * @damp) + ((@forces * @i_mass) * dt)
      @a_velocity = (@a_velocity * @damp) + ((@torque * @i_moment) * dt)

      @forces.zero!
      @torque = 0.0

      @pos.add_scaled(@vel, dt)
      @angle += (@a_velocity * dt)

      set_transform
    end

    def add_force_at(force, point)
      @forces.add(force)

      r = point - @transform.transform_vert(cog)
      @torque += r.cross(force)
    end

    def add_force(force)
      @forces.add(force)
    end

  end
end