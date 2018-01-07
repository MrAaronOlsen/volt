module Volt
  class Matrix
  end

  class Matrix2x3 < Matrix
    attr_reader :a, :c, :tx
    attr_reader :b, :d, :ty

    def initialize(a, c, tx, b, d, ty)
      @a, @b, @c, @d = a.to_f, b.to_f, c.to_f, d.to_f
      @tx, @ty = tx.to_f, ty.to_f
    end

    class << self
      def new_identity
        Mat23.new(1.0, 0.0, 0.0, 0.0, 1.0, 0.0)
      end

      def new_translate(vect)
        Mat23.new(1, 0, vect.x, 0, 1, vect.y)
      end

      def new_rotate(degrees)
      	rot = V.from_angle(degrees);
      	Mat23.new(rot.x, -rot.y, 0.0, rot.y,  rot.x, 0.0)
      end

      def new_transform(degrees, vect)
        rot = V.from_angle(degrees);
        Mat23.new(rot.x, -rot.y, vect.x, rot.y, rot.x, vect.y)
      end
    end

# Math

    def transform_vert(vert)
      Vect.new(@a*vert.x + @c*vert.y + @tx, @b*vert.x + @d*vert.y + @ty)
    end
  end

  Mat23 = Matrix2x3
end