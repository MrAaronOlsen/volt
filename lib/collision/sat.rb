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
        include Structs

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

            manifold.add_sat_data(shadow1.get_overlap(shadow2), face.normal, poly1_verts, poly2_verts)
          end

          d = Geo.get_centroid(poly2_verts) - Geo.get_centroid(poly1_verts)
          manifold.flip_normal if d.dot(manifold.contact_normal) < 0

          true
        end

        # Given two polygons, will find the two faces most facing each other in reference to the given axis.
        # The reference face will the one most perpendicular to the axis.
        # Axis: --->
        #  ___      ____
        # |   r    i   /
        # |___r   i__ /
        #

        def find_contact_faces(verts1, verts2, axis)
          points1 = Array.new
          points2 = Array.new

          verts1.each do |vert|
            points1 << PointAlongAxis.new(Geo.distance_along_axis(axis.flipped, vert), vert)
          end

          verts2.each do |vert|
            points2 << PointAlongAxis.new(Geo.distance_along_axis(axis, vert), vert)
          end

          farthest = points1.max_by(2) { |point| point.distance }
          closest = points2.max_by(2) { |point| point.distance }

          face1 = Face.new(farthest[0].point, farthest[1].point)
          face2 = Face.new(closest[0].point, closest[1].point)

          if face1.axis.dot(axis).abs <= face2.axis.dot(axis).abs
            return ContactFaces.new(face1, face2)
          else
            return ContactFaces.new(face2, face1)
          end
        end
      end
    end
  end
end