module Volt
  module Contact
    class PolyLine
      attr_reader :manifold

      def initialize(poly, line)
        @poly, @line = poly, line
      end

      def query
        # Get world coords of verts in play
        line_start = Ref.get(@line.body.trans, @line.verts[0])
        line_end = Ref.get(@line.body.trans, @line.verts[1])
        line_edge = Edge.new(line_start, line_end)

        poly_centroid = Ref.get(@poly.body.trans, @poly.centroid)
        poly_verts = Ref.get_all(@poly.body.trans, @poly.verts)

        # First we check if this is a line to edge contact by using ray casting. Unfortunately we need to check both
        # ends of the line  make sure we know which end is inside the poly
        line_contact = line_edge.from if Geo.point_is_inside_poly(poly_verts, line_edge.from)
        line_contact = line_edge.to if line_contact.nil? && Geo.point_is_inside_poly(poly_verts, line_edge.to)

        # If we have a line contact then find the rest of the contact data and return it.
        if line_contact.exists?
          edge = Geo.find_edge_intersecting_with_line(poly_verts, line_edge.from, line_edge.to)

          if edge
            @manifold = Manifold.new do |man|
              man.penetration = line_contact.distance_to(edge.contact_loc)
              man.contact_normal = edge.normal
              man.contact_loc = edge.contact_loc
            end

            return true
          end
        end

        # Initial contact normal. Does not matter yet what direction it's facing.
        contact_normal = line_edge.normal
        line_axis = line_edge.axis.unit

        # Do a SAT check on the line's axis
        return false if !SAT.check_for_poly_line(poly_verts, line_edge.from, line_axis)

        # Do a SAT check on the Edge's axis and get a penetration if it's there
        penetration = SAT.check_for_poly_face(poly_verts, [line_edge.from, line_edge.to], contact_normal)
        return false if !penetration

        # Flip the normal if the poly centroid is on the other side
        contact_normal.mult(-1) if Geo.determinant(line_edge.to, line_edge.from, poly_centroid) == -1

        # To find the contact location we'll need to check each edge of the poly with the line
        edge = Geo.find_edge_intersecting_with_line(poly_verts, line_edge.from, line_edge.to)

        return false if !edge
        contact_loc = edge.contact_loc

        @manifold = Manifold.new do |man|
          man.penetration = penetration
          man.contact_normal = contact_normal
          man.contact_loc = contact_loc
        end

        return true
      end

      def manifold
        @manifold.tap do |man|
          man.add_bodies(@poly.body, @line.body)
        end
      end
    end
  end
end