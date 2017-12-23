module Volt
  class Body
    attr_reader :i_mass, :forces
    attr_reader :pos, :vel, :acc, :mass, :damp

    def initialize
      block_given? ? (yield self) : self.config
    end

    def config(vel: V.new, pos: V.new, acc: V.new, mass: 0.0, damp: 1.0)
      @pos, @vel, @acc = pos, vel, acc
      @mass, @damp = mass.to_f, damp.to_f

      set_i_mass(mass)
    end

    def add_force(force)
      @forces.add(force)
    end

    def add_impulse(impulse)
    end

    def update(dt)
      return if @mass <= 0

      @pos.add_scaled!(@vel, dt)

      arc = (@acc + @forces) * @i_mass

      @vel.add_scaled!(arc, dt)
      @vel.scale!( 0.99**dt )

      @forces.zero!
    end

    private

    def set_i_mass(mass)
      mass > 0.0 ? @i_mass = 1.0 / mass : @i_mass = 0.0
    end
  end
end