module Volt
  module Collision
    module Handlers
      class PolyLine < Base

        def initialize(poly, line)
          @poly, @line = poly, line
        end

        def query
          # @contact = Contact.new(@poly, @line)
          # @contact.handler = self

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

          # If we have a line contact then find the rest of the contact data
          if line_contact.exists?
            @contact_face = find_face_intersecting_with_line(poly_verts, line_face.start, line_face.end)

            if @contact_face.exists?
              @contact_loc = @contact_face.contact_loc
              @contact_normal = @contact_face.normal
              @penetration = line_contact.distance_to(@contact_loc)
              return true
            end
          end

          # Otherwise we check for a poly to line contact

          # First we check the contact along the line's axis
          line_axis = line_face.axis

          body_minmax = MinMax.by_projection(poly_verts, line_axis)
          line_minmax = MinMax.by_projection([line_face.start, line_face.end], line_axis)

          # If the poly's min and max overlap the line's min we have a contact on the line's axis
          return false unless body_minmax.max > line_minmax.min || body_minmax.min < line_minmax.max

          # Initial contact normal
          @contact_normal = line_face.normal

          # Then check for contact along the lines normal
          # Gets the min and max projection onto the contact normal
          body_minmax = MinMax.by_projection(poly_verts, @contact_normal)
          line_minmax = MinMax.by_projection([line_face.start, line_face.end], @contact_normal)

          # If the poly's min and max are on either side of the line we have a contact on the normal axis
          return false unless body_minmax.max > line_minmax.min && body_minmax.min < line_minmax.min

          # Flip the normal if the poly centroid is on the other side
          if determinant(line_face.end, line_face.start, poly_centroid) == -1
            @contact_normal.mult(-1)
          end

          # Penetration is going to be smallest of both possibilities since we could be on either side of the line
          @penetration = [body_minmax.max - line_minmax.min, line_minmax.max - body_minmax.min].min

          # To find the contact location we'll need to check each face of the poly with the line
          @contact_loc = find_contact_point_of_line_with_poly(poly_verts, line_face.start, line_face.end)
          @contact_loc.exists?
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
end