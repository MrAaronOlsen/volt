module Volt
  class Body

    # position
    attr_accessor :pos
    attr_reader :cog, :transform
    # linear
    attr_reader :vel, :acc
    # angular
    attr_reader :angle, :a_velocity, :inertia, :i_inertia
    # forces
    attr_reader :torque, :forces
    # attributes
    attr_reader :mass, :i_mass, :shapes, :damp

    def initialize
      block_given? ? (yield self) : self.config
    end

    def config(vel: V.new, pos: V.new, acc: V.new, mass: 0.0, damp: 1.0, angle: 0.0, inertia: 0.0)
      @pos, @vel, @acc = pos, vel, acc
      @mass, @damp = mass.to_f, damp.to_f
      @angle = angle.to_f
      @inertia = inertia

      set_i_mass(mass)
      set_i_inertia(inertia)

      @a_velocity = 0.0
      @torque = 0.0

      @shapes = []
      @forces = Vect.new
      @transform = Mat23.new_identity
    end

    def add_shape(shape)
      @shapes << shape

      set_cog
      set_transform
    end

    def set_cog
      bot = 0

      top = @shapes.reduce(V.new) do |top, shape|
        bot += shape.mass
        top + shape.world_centroid * shape.mass
      end

      @cog = top / bot
    end

    def set_transform
      @transform = Mat23.new_transform(@angle, @pos)
    end

# Life cycle functions

    def update(dt)
      return if @mass <= 0

      arc = @acc.copy
      arc.add_scaled(@forces, @i_mass)

      @vel.add_scaled(arc, dt)
      @vel.scale( @damp**dt )

      @a_velocity = (@a_velocity * @damp) + ((@torque * @i_inertia) * dt)

      @pos.add_scaled(@vel, dt)
      @angle += (@a_velocity * dt)

      set_transform

      @forces.zero!
      @torque = 0.0
    end

    def add_force(force)
      @forces.add(force)
    end

    def add_torque(torque)
      @torque += torque
    end

    def add_impulse(impulse)
    end

    private

    def set_i_mass(mass)
      mass > 0.0 ? @i_mass = 1.0 / mass : @i_mass = 0.0
    end

    def set_i_inertia(inertia)
      inertia > 0.0 ? @i_inertia = 1.0 / inertia : @i_inertia = 0.0
    end
  end
end