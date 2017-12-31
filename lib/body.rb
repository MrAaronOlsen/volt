module Volt
  class Body
    attr_reader :i_mass, :forces
    attr_accessor :pos, :vel, :acc, :mass, :damp
    attr_reader :cog, :transform
    attr_reader :shapes

    def initialize
      block_given? ? (yield self) : self.config
    end

    def config(vel: V.new, pos: V.new, acc: V.new, mass: 0.0, damp: 1.0)
      @pos, @vel, @acc = pos, vel, acc
      @mass, @damp = mass.to_f, damp.to_f

      set_i_mass(mass)
      @shapes = []
      @forces = Vect.new
    end

    def add_force(force)
      @forces.add(force)
    end

    def add_impulse(impulse)
    end

    def update(dt)
      return if @mass <= 0

      @pos.add_scaled(@vel, dt)

      arc = @acc.copy
      arc.add_scaled(@forces, @i_mass)

      @vel.add_scaled(arc, dt)
      @vel.scale( @damp**dt )

      @forces.zero!
    end

    def add_shape(shape)
      @shapes << shape
    end

    private

    def set_i_mass(mass)
      mass > 0.0 ? @i_mass = 1.0 / mass : @i_mass = 0.0
    end
  end
end