module Volt
  class Body < Traits

    def initialize
      super

      yield self
    end

# Main Update

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

# Lifecycle Methods

    def add_force(force)
      @forces.add(force)
    end

    def add_force_at(force, vert)
      @forces.add(force)

      r = point - @trans.transform_vert(cog)
      @torque += r.cross(force)
    end

    def add_impulse(impulse)
      @vel += impulse * @i_mass
    end

    def add_impulse_at(impulse, point)
      @vel += impulse * @i_mass

      r = point - @trans.transform_vert(cog)
      @a_vel += r.cross(impulse) * @i_moment
    end

    def add_rotation(vel)
      @a_vel += vel
    end
  end
end