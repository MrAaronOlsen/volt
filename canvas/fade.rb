module Canvas
  class Fade
    attr_reader :sprite, :type, :alpha
    attr_reader :lifespan, :born, :dead

    def initialize(sprite, lifespan)
      @sprite, @type, @alpha = sprite, sprite.type, sprite.color.a
      @fade = @alpha / lifespan
      @lifespan = lifespan
      @born = Time.now
      @dead = false
    end

    def draw(dt)
      @sprite.color.fade(-@fade * dt)
      Draw.shape[@type].call(@sprite)

      @dead = true if Time.now - @born >= lifespan
    end
  end
end