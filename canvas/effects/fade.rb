module Canvas
  class Fade
    attr_reader :sprite, :type, :alpha
    attr_reader :lifespan, :born, :dead

    def initialize(sprite, lifespan)
      @sprite, @type, @alpha = sprite, sprite.type, sprite.color.a
      lifespan.zero? ? @fade = lifespan : @fade = @alpha / lifespan
      @lifespan = lifespan
      @born = Time.now
      @dead = false
    end

    def draw(dt)
      Draw.shape[@type].call(@sprite)

      if dt.zero?
        @lifespan += Time.now - @born
        return
      end

      @sprite.color.fade(@fade * -dt)
      @dead = true if Time.now - @born >= lifespan
    end
  end
end