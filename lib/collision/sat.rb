module Volt
  module Collision
    class SAT
      attr_reader :verts, :axis
      attr_reader :min, :max

      def initialize(verts, axis)
        @verts, @axis = verts, axis

        get_projections
      end

      def get_projections
        minmax = @verts.map do |vert|
          vert.dot(@axis)
        end.minmax

        @min, @max = minmax[0], minmax[1]
      end

      def has_gap(sat)
        @max <= sat.min || sat.max <= @min
      end

      def overlaps(sat)
        sat.min <= @max  && @min <= sat.max
      end

      def get_overlap(sat)
        [@max - sat.min, sat.max - @min].min
      end

      class << self
      # Will return the penetration of a poly with a line otherwise returns false
        def check_for_poly_line(poly_verts, line_vert, line_axis)
          poly_sat = SAT.new(poly_verts, line_axis)
          line_sat = SAT.new([line_vert], line_axis)

          if poly_sat.max > line_sat.min || poly_sat.min < line_sat.max
            return poly_sat.get_overlap(line_sat)
          else
            return false
          end
        end

        # Will return the penetration of a poly with a face otherwise returns false
        def check_for_poly_face(poly_verts, face_verts, axis)
          poly_sat = SAT.new(poly_verts, axis)
          face_sat = SAT.new(face_verts, axis)

          if poly_sat.overlaps(face_sat)
            return poly_sat.get_overlap(face_sat)
          else
            return false
          end
        end

        # Will return true at the first gap found between two polygons
        def check_for_poly_poly(poly1_verts, poly2_verts, manifold)
          count = poly1_verts.count

          poly1_verts.each_with_index do |face_start, i|
            face_end = poly1_verts[(i+1) % count]

            face = Face.new(face_end, face_start)

            shadow1 = SAT.new(poly1_verts, face.normal)
            shadow2 = SAT.new(poly2_verts, face.normal)

            return false if shadow1.has_gap(shadow2)

            face.correct_normal(poly1_verts, poly2_verts)
            manifold.add_sat_data(shadow1.get_overlap(shadow2), face.normal)
          end

          true
        end
      end
    end
  end
end