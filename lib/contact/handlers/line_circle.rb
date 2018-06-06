module Volt
  module Contact
    class LineCircle
      attr_reader :manifold

      def initialize(line, circ)
        @line, @circ = line, circ
      end

      def query
        line_start = Ref.get(@line.body.trans, @line.verts[0])
        line_end = Ref.get(@line.body.trans, @line.verts[1])

        center = Ref.get(@circ.body.trans, @circ.centroid)
        radius = @circ.radius

        segment = line_start - line_end
        d = line_start - center

        projection = d.projection_onto(segment)
        ref_point = line_start - projection

        penetration = radius - ref_point.distance_to(center)

        if penetration > 0 && projection.dot(segment) > 0 && projection.mag < segment.mag
          @manifold = Manifold.new do |man|
            man.penetration = penetration
            man.contact_normal = (ref_point - center).unit
            man.contact_loc = ref_point + man.mtv
          end

          return true
        else
          to_start = center.distance_to(line_start)

          if to_start < radius
            @manifold = Manifold.new do |man|
              man.penetration = radius - to_start
              man.contact_normal = (line_start - center).unit
              man.contact_loc = line_start + man.mtv
            end

            return true
          else
            to_end = center.distance_to(line_end)

            if to_end < radius
              @manifold = Manifold.new do |man|
                man.penetration = radius - to_end
                man.contact_normal = (line_end - center).unit
                man.contact_loc = line_end + man.mtv
              end

              return true
            end
          end

          return false
        end
      end

      def manifold
        @manifold.tap do |man|
          man.add_bodies(@line.body, @circ.body)
        end
      end
    end
  end
end