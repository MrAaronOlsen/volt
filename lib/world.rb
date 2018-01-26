module Volt
  class World
    attr_accessor :bodies

    def initialize
      @bodies = []
    end

    def update(dt)
      return if dt <= 0.0

      bodies.each do |body|
        body.update(dt)
      end
    end

    def add_body(body)
      @bodies << body
    end

    def draw
      @bodies.each { |body| body.draw }
    end
  end
end