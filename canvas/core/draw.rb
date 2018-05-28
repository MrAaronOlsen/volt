module Canvas
  class Draw

    class << self
      def shape
         {
           circle: lambda { |sprite| circle(sprite) },
           line: lambda { |sprite| line(sprite) },
           tri: lambda { |sprite| tri(sprite) },
           rect: lambda { |sprite| rect(sprite) },
           poly: lambda { |sprite| poly(sprite) }
         }
      end

      def circle(sprite)
        Pencil.circle(sprite.center, sprite.radius, sprite.color.get, sprite.fill, sprite.z)
      end

      def line(sprite)
        Pencil.line(sprite.verts, sprite.color.get, sprite.z)
      end

      def tri(sprite)
        Pencil.tri(sprite.verts, sprite.color.get, sprite.fill, sprite.z)
      end

      def rect(sprite)
        Pencil.rect(sprite.verts, sprite.color.get, sprite.fill, sprite.z)
      end

      def poly(sprite)
        Pencil.poly(sprite.verts, sprite.center,sprite.color.get, sprite.fill, sprite.z)
      end
    end
  end
end