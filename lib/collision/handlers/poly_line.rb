module Volt
  module Collision
    class PolyLine < Base

      def initialize(poly, line)
        @poly, @line = poly, line
      end

      def query
        # Get world coords of verts in play
        line_face = Face.new(Ref.get(@line.body, @line.verts[0]), Ref.get(@line.body, @line.verts[1]))
        @contact_face = Face.new(line_face.start, line_face.end)

        poly_centroid = Ref.get(@poly.body, @poly.centroid)
        poly_verts = Ref.get_all(@poly.body, @poly.verts)
        poly_verts_count = poly_verts.count

        # First we check if this is a line to face contact by using ray casting. Unfortunately we need to check both
        # ends of the line to really make sure we know which end is inside the poly
        line_contact = line_face.start if point_is_inside_poly(poly_verts, line_face.start)
        line_contact = line_face.end if line_contact.nil? && point_is_inside_poly(poly_verts, line_face.end)

        # If we have a line contact then find the rest of the contact data and return it.
        if line_contact.exists?
          @contact_face = find_face_intersecting_with_line(poly_verts, line_face.start, line_face.end)

          if @contact_face
            @contact_loc = @contact_face.contact_loc
            @contact_normal = @contact_face.normal
            @penetration = line_contact.distance_to(@contact_loc)

            return true
          end
        end

        # Initial contact normal. Does not matter yet what direction it's facing.
        @contact_normal = line_face.normal
        line_axis = line_face.axis.unit

        # Do a SAT check on the line's axis
        return false if !SAT.check_for_poly_line(poly_verts, line_face.start, line_axis)

        # Do a SAT check on the face's axis and get a penetration if it's there
        @penetration = SAT.check_for_poly_face(poly_verts, [line_face.start, line_face.end], @contact_normal)
        return false if !@penetration

        # Flip the normal if the poly centroid is on the other side
        @contact_normal.mult(-1) if determinant(line_face.end, line_face.start, poly_centroid) == -1

        # To find the contact location we'll need to check each face of the poly with the line
        @contact_face = find_face_intersecting_with_line(poly_verts, line_face.start, line_face.end)

        return false if !@contact_face
        @contact_loc = @contact_face.contact_loc
      end

      def get_contact
        Contact.new(@poly, @line) do |contact|
          contact.handler = self
          contact.penetration = @penetration
          contact.contact_normal = @contact_normal
          contact.contact_loc = @contact_loc
          contact.contact_face = @contact_face
        end
      end
    end
  end
end