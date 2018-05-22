module Volt
  module Collision
    module Handlers
      class PolyLine < Base
        attr_reader :type

        def initialize(poly, line)
          @poly, @line = poly, line
        end

        def query
          # Get world coords of verts in play
          @line_start = Ref.get(@line.body, @line.verts[0])
          @line_end = Ref.get(@line.body, @line.verts[1])
          @contact_face = Face.new(@line_start, @line_end)

          @poly_centroid = Ref.get(@poly.body, @poly.centroid)
          @poly_verts = Ref.get_all(@poly.body, @poly.verts)
          @poly_verts_count = @poly_verts.count

          # First we check if this is a line to face contact by using ray casting. Unfortunately we need to check both
          # ends of the line to really make sure we know which end is inside
          @face_intersections = 0

          @poly_verts.each_with_index do |face_start, i|
            face_end = @poly_verts[(i+1) % @poly_verts_count]

            if line_line_intersection(V.new(0, 0), @line_start, face_start, face_end)
              @line_point = @line_start
              @face_intersections += 1
            end
          end

          if @face_intersections.modulo(2).zero?
            @face_intersections = 0

            @poly_verts.each_with_index do |face_start, i|
              face_end = @poly_verts[(i+1) % @poly_verts_count]

              if line_line_intersection(V.new(0, 0), @line_end, face_start, face_end)
                @line_point = @line_end
                @face_intersections += 1
              end
            end
          end

          # If our ray intersected an odd number of faces we're inside the poly, so do a contact for it.
          if !@face_intersections.modulo(2).zero?
            @poly_verts.each_with_index do |face_start, i|
              face_end = @poly_verts[(i+1) % @poly_verts_count]

              @contact_loc = line_line_intersection(face_start, face_end, @line_start, @line_end)

              if @contact_loc
                @contact_face = Face.new(face_start, face_end)
                @contact_normal = (face_end - face_start).normal.unit
                @penetration = @line_point.distance_to(@contact_loc)
                break
              end
            end

            # If for some reason we still don't have a contact we'll skip it and hope we find something next time
            return @contact_loc.exists?
          end

          # Otherwise we check for a poly to line contact

          # First we check the contact along the line's axis
          line_segment = (@line_start - @line_end).unit

          @body_minmax = MinMax.by_projection(@poly_verts, line_segment)
          @line_minmax = MinMax.by_projection([@line_start, @line_end], line_segment)

          # If the poly's min and max overlap the lines min max we have a contact on the line's axis
          return false unless @body_minmax.max > @line_minmax.min || @body_minmax.min < @line_minmax.max

          # Initial contact normal
          @contact_normal = (@line_end - @line_start).normal.unit

          # Then check for contact along the lines normal
          # Gets the min and max projection onto the contact normal
          @body_minmax = MinMax.by_projection(@poly_verts, @contact_normal)
          @line_minmax = MinMax.by_projection([@line_start, @line_end], @contact_normal)

          # If the poly's min and max are on either side of the line we have a contact on the normal axis
          return false unless @body_minmax.max > @line_minmax.min && @body_minmax.min < @line_minmax.min

          # Flip the normal if the poly centroid is on the other side
          if determinant(@line_end, @line_start, @poly_centroid) == -1
            @contact_normal.mult(-1)
          end

          # Penetration is going to be smallest of both possibilities since we could be on either side of the line
          @penetration = [@body_minmax.max - @line_minmax.min, @line_minmax.max - @body_minmax.min].min

          # To find the contact location we'll need to check each face of the poly with the line
          @poly_verts.each_with_index do |face_start, i|
            face_end = @poly_verts[(i+1) % @poly_verts_count]

            @contact_loc = line_line_intersection(face_start, face_end, @line_start, @line_end)
            break if @contact_loc.exists?
          end

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

      private


      end
    end
  end
end