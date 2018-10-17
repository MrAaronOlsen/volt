module Volt
  module Contact
    class PolyCircle
      attr_reader :manifold

      def initialize(poly, circ)
        @poly, @circ = poly, circ
      end

      def query
        center = Ref.get(@circ.body.trans, @circ.centroid)
        radius = @circ.radius

        verts = Ref.get_all(@poly.body.trans, @poly.verts)
        verts = verts.sort_by { |vert| vert.distance_to(center) }

        line_start, line_end = verts[0], verts[1]

        segment = line_start - line_end
        thread = line_start - center

        projection = thread.projection_onto(segment)

        contact_loc = line_start - projection
        contact_normal = (contact_loc - center).unit
        penetration = radius - contact_loc.distance_to(center)

        if penetration > 0 && projection.dot(segment) > 0 && projection.mag < segment.mag
          @manifold = Manifold.new do |man|
            man.penetration = penetration
            man.contact_normal = contact_normal
            man.contact_loc = contact_loc
          end

          return true
        else
          to_start = center.distance_to(line_start)

          if to_start < radius
            @manifold = Manifold.new do |man|
              man.penetration = radius - to_start
              man.contact_normal = (line_start - center).unit
              man.contact_loc = line_start
            end

            return true
          end

          to_end = center.distance_to(line_end)

          if to_end < radius
            @manifold = Manifold.new do |man|
              man.penetration = radius - to_end
              man.contact_normal = (line_end - center).unit
              man.contact_loc = line_end
            end

            return true
          end
        end

        return false
      end

      def manifold
        @manifold.tap do |man|
          man.add_bodies(@poly.body, @circ.body)
        end
      end
    end
  end
end