module Volt
  class World
    attr_accessor :bodies, :broad_phase

    def initialize
      @bodies = []
      @broad_phase = BroadPhase::Handler.new
    end

    def update(dt)
      return if dt <= 0.0

      @broad_phase.query(bodies)

      bodies.each do |body|
        body.update(dt)
      end
    end

    def add_body(body)
      @bodies << body
    end

    def add_bodies(bodies)
      bodies.each { |body| add_body(body) }
    end

    def draw
      @bodies.each { |body| body.draw }
    end
  end
end