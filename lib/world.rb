module Volt
  class World
    attr_accessor :bodies
    attr_reader :dt

    def initialize
      @bodies = []
      @contacts = []
      @Arbitor = Collision::Arbitor.new
    end

    def update(dt)
      @dt = dt
      return if dt <= 0.0

      @Arbitor.query(bodies)
      @contacts = @Arbitor.resolve(dt)

      bodies.each do |body|
        body.update(dt)
      end
    end

    def debug(pause)
      @contacts.each { |contact| contact.debug }
    end

    def add_body(body)
      @bodies << body
    end

    def add_bodies(bodies)
      bodies.each { |body| add_body(body) }
    end
  end
end