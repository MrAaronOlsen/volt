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
    end

    def mult_mat23(mat23)
      Mat23.new(
        @a*mat23.a + @c*mat23.b, @a*mat23.c + @c*mat23.d, @a*mat23.tx + @c*mat23.ty + @tx,
        @b*mat23.a + @d*mat23.b, @b*mat23.c + @d*mat23.d, @b*mat23.tx + @d*mat23.ty + @ty
      )
    end

    def transform_vert(vert)
      Vect.new(@a*vert.x + @c*vert.y + @tx, @b*vert.x + @d*vert.y + @ty)
    end
  end

  Mat23 = Matrix2x3
end