module Volt
  class Joints
    attr_accessor :length, :restitution
    attr_reader :body1, :body2
    attr_reader :pos1, :pos2

    def current_length
      (pos1 - pos2).mag
    end

    def pos1
      @body1.pos
    end

    def pos2
      @body2.pos
    end
  end
end