module Volt
  class BodyBuilder
    # position
    attr_accessor :pos
    attr_reader :transform
    # linear
    attr_accessor :vel, :acc
    # angular
    attr_accessor :angle, :a_velocity
    attr_reader :moment, :i_moment
    # forces
    attr_reader :torque, :forces
    # attributes
    attr_accessor :damp
    attr_reader :mass, :i_mass, :shapes

    def initialize()
      @pos, @vel, @acc = V.new, V.new, V.new
      @mass, @moment, @damp = 0.0, 0.0, 1.0
      @angle, @a_velocity, @torque = 0.0, 0.0, 0.0

      @shapes = []
      @forces = V.new
      @transform = Mat23.new_identity
    end

    def set_pos(x, y)
      @pos = V.new(x, y)
    end

    def mass=(mass)
      @mass = mass
      set_i_mass(@mass)
    end

    def moment=(moment)
      @moment = moment
      set_i_moment(@moment)
    end

    private

    def set_i_mass(mass)
      mass > 0.0 ? @i_mass = 1.0 / mass : @i_mass = 0.0
    end

    def set_i_moment(moment)
      moment > 0.0 ? @i_moment = 1.0 / moment : @i_moment = 0.0
    end
  end
end