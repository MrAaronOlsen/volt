module Volt
  class World
    attr_accessor :bodies
    attr_reader :dt

    def initialize
      @bodies = []
      @contacts, @joints = [], []
      @Arbitor = Arbitor.new
    end

    def update(dt)
      @dt = dt
      return if dt <= 0.0

      @Arbitor.query(@bodies, @joints)
      @contacts = @Arbitor.resolve(dt)
      @Arbitor.reset

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

    def add_joint(joint)
      @joints << joint
    end

    def add_joints(joints)
      joints.each { |joint| add_joint(joint) }
    end
  end
end