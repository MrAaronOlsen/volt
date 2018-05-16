module Volt

  class Reference

    class << self
      def get(body, vert)
        body.trans.transform_vert(vert)
      end

      def get_all(body, verts)
        verts.map { |vert| body.trans.transform_vert(vert) }
      end
    end
  end

  Ref = Reference
end