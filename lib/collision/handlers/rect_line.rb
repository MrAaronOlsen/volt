module Volt
  module Collision
    module Handlers
      class RectLine < Base
        attr_reader :type

        def initialize(rect, line)
          @rect, @line = rect, line
        end

        def query
          @line_start = @line.world_position(@line.verts[0])
          @line_end = @line.world_position(@line.verts[1])

          @rect_verts = @rect.verts.map { |vert| @rect.world_position(vert) }
          @rect_center = @rect.world_position(@rect.centroid)

          @rect_verts.each_with_index do |vert1, i|
            vert2 = @rect_verts[(i+1) % @rect_verts.count]
            @contact_loc = line_line_intersection(@line_start, @line_end, vert1, vert2)

            if @contact_loc
              collide(@line_start, @line_end, vert1, vert2)
              return true
            end
          end
          
          false
        end

        def debug
          Canvas::Pencil.circle(@contact_loc, 10, Canvas::Color.yellow, true, 2)
        end

        def get_contact
          Contact.new(@rect, @line) do |contact|
            contact.handler = self
            contact.penetration = @penetration
            contact.contact_normal = @contact_normal
            contact.contact_loc = @contact_loc
          end
        end

      private

        def collide(line_start, line_end, side_start, side_end)
          line_seg = line_end - line_start
          side_seg = side_end - side_start

          closest_line = closest_point_to_line([line_start, line_end], side_start, side_end)
          closest_side = closest_point_to_line([side_start, side_end], line_start, line_end)

          if closest_line.distance < closest_side.distance
            # Line has collided with a box side
            @penetration = closest_line.distance
            @line_center = line_start + (line_seg * 0.5)

            @contact_normal = side_seg.normal.unit
          else
            # Box corner has collided with the line
            @penetration = closest_side.distance
            @line_center = side_start + (side_seg * 0.5)

            @face_start, @face_end = line_start, line_end
            d = determinant(line_start, line_end, closest_side.point)
            @contact_normal = line_seg.normal.unit * d
          end
        end

        def closest_point_to_line(points, line_start, line_end)
          closest = nil

          points.each do |point|
            distance = distance_of_point_to_line(point, line_start, line_end)

            if closest.nil? || distance < closest.distance
              closest = Struct.new(:distance, :point).new(distance, point)
            end
          end

          return closest
        end
      end
    end
  end
end