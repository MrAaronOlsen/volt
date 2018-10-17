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

      @vel = (@vel * @damp) + (@forces * @i_mass)
      @a_vel = (@a_vel * @damp) + (@torque * @i_moment)

      @forces.zero!
      @torque = 0.0

      @pos += @vel * dt
      @angle += @a_vel * dt

      set_transform
      @bounding.update
    end

# Lifecycle Methods

    def add_force(force)
      @forces.add(force)
    end

    def add_force_at(force, vert)
      @forces.add(force)

      r = point - Ref.get(@trans, cog)
      @torque += r.cross(force)
    end

    def add_impulse(impulse)
      @vel += impulse * @i_mass
    end

    def add_lin_impulse(impulse)
      @vel += impulse * @i_mass
    end

    def add_rot_impulse(impulse, point)
      r = point - Ref.get(@trans, cog)
      @a_vel += r.cross(impulse) * @i_moment
    end

    def add_impulse_at(impulse, point)
      @vel += impulse * @i_mass

      r = point - Ref.get(@trans, cog)
      @a_vel += r.cross(impulse) * @i_moment
    end

    def add_impulse_with(impulse, contact)
      add_impulse(impulse)
      @a_vel += contact.cross(impulse) * @i_moment
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

    def add_callback_block(type, &block)
      callbacks[type] << block
    end

    def run_callbacks(type, contact)
      callbacks[type].each { |callback| callback.call(self, contact)}
    end

# Broadphase query

    def broadphase(body)
      @bounding.query(body.bounding)
    end
  end
end