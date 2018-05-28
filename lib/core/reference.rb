module Volt
  class Reference

    class << self
      def get(trans, vert)
        trans.transform_vert(vert)
      end

      def get_all(trans, verts)
        verts.map { |vert| trans.transform_vert(vert) }
      end
    end
  end

  Ref = Reference
end