module Volt
  class World
    attr_accessor :bodies, :collision

    def initialize
      @bodies = []
      @Arbitor = Collision::Arbitor.new
    end

    def update(dt)
      return if dt <= 0.0

      @Arbitor.query(bodies)
      @Arbitor.resolve(dt)

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