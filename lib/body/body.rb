module Volt
  class Body < Traits
    attr_reader :callbacks

    def initialize
      super

      @callbacks = {
        pre: Array.new,
        post: Array.new
      }

      yield self if block_given?
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

      r = point - world_position(cog)
      @torque += r.cross(force)
    end

    def add_impulse(impulse)
      @vel += impulse * @i_mass
    end

    def add_impulse_at(impulse, point)
      @vel += impulse

      r = point - world_position(cog)
      @a_vel += r.cross(impulse) * @i_moment
    end

    def add_rotation(vel)
      @a_vel += vel
    end

    def set_vel(vel)
      @vel = vel
    end

    def set_a_vel(a_vel)
      @a_vel = a_vel
    end

# Call back functions

    def add_callback(type, callback)
      callbacks[type] << callback
    end

    def run_callbacks(type, contact)
      callbacks[type].each { |callback| callback.call(self, contact)}
    end

# Transform Methods

    def world_position(vert)
      @trans.transform_vert(vert)
    end
  end
end