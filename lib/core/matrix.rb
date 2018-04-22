module Volt

  class Matrix
    attr_reader :a, :c, :tx
    attr_reader :b, :d, :ty

    def initialize(a, c, tx, b, d, ty)
      @a, @c, @tx = a.to_f, c.to_f, tx.to_f
      @b, @d, @ty = b.to_f, d.to_f, ty.to_f
    end

# Handy initializers

    class << self
      def new_identity
        Mat.new(1.0, 0.0, 0.0, 0.0, 1.0, 0.0)
      end

      def new_translate(vect)
        Mat.new(1, 0, vect.x, 0, 1, vect.y)
      end

      def new_rotate(angle)
      	rot = V.from_angle(angle);
      	Mat.new(rot.x, -rot.y, 0.0, rot.y,  rot.x, 0.0)
      end

      def new_transform(vect, angle)
        rot = V.from_angle(angle);
        Mat.new(rot.x, -rot.y, vect.x, rot.y, rot.x, vect.y)
      end
    end

# Math

    def transform_vert(vert)
      V.new(@a*vert.x + @c*vert.y + @tx, @b*vert.x + @d*vert.y + @ty)
    end

    def inverse
      i = 1.0/((@a * @d) - (@c * @b))

      Mat.new(
        @d * i, -@c * i, (@c * @ty - @tx * @d) * i,
        -@b * i,  @a * i, (@tx * @b - @a * @ty) * i
      )
    end
  end

  Mat = Matrix
end