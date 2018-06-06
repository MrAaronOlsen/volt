module Volt
  module Contact
    class Clip

      class << self
        def from_manifold(manifold)
          ref = manifold.reference
          inc = manifold.incident

          refv = ref.axis.unit

          o1 = refv.dot(ref.from)
          cp = clip(inc.from, inc.to, refv, o1)

          return if cp.length < 2

          # clip whats left of the incident edge by the second vertex of the reference edge
          # but we need to clip in the opposite direction so we flip the direction and offset
          o2 = refv.dot(ref.to);
          cp = clip(cp[0], cp[1], refv * -1, o2 * -1)

          # if we dont have 2 points left then fail
          return if cp.length < 2

          # get the reference edge normal
          refNorm = manifold.contact_normal.flipped

          # if we had to flip the incident and reference edges then we need to flip the reference edge normal to
          # clip properly
          refNorm.flip if manifold.flipped

          # get the largest depth
          max = refNorm.dot(ref.from)

          # make sure the final points are not past this maximum
          depth1 = refNorm.dot(cp[0]) - max
          depth2 = refNorm.dot(cp[1]) - max

          cp.delete(cp[0]) if depth1 < 0.0
          cp.delete(cp[1]) if depth2 < 0.0

          manifold.contact_locs = cp
        end

        def clip(v1, v2, n, o)
          Array.new.tap do |cp|
            d1 = n.dot(v1) - o;
            d2 = n.dot(v2) - o;

            # if either point is past o along n then we can keep the point
            cp.push(v1) if (d1 >= 0.0)
            cp.push(v2) if (d2 >= 0.0)

            # finally we need to check if they are on opposing sides so that we can compute the correct point
            if d1 * d2 < 0.0
              # if they are on different sides of the offset, d1 and d2 will be a (+) * (-)
              # and will yield a (-) and therefore be less than zero get the vector for the edge we are clipping
              e = v2 - v1
              # compute the location along e
              u = d1 / (d1 - d2)
              e.mult(u)
              e.add(v1)
              # add the point
              cp.push(e)
            end
          end
        end

      end
    end
  end
end