module Volt
  module Collision
    module Handlers
      class Base

        def package
          Struct.new(:point, :distance)
        end

        def get_contact
          Contact.new(@body1.body, @body2.body) do |contact|
            contact.handler = self
            contact.penetration = @penetration
            contact.contact_normal = @contact_normal
            contact.contact_loc = @contact_loc
          end
        end

        def distance_of_point_to_line(point, line_start, line_end)
          segment = line_start - line_end
          thread = line_start - point

          projection = thread.projection_onto(segment)
          distance = point.distance_to(line_start - projection)

          package.new(point, distance)
        end

        def line_line_intersection(p0, p1, p2, p3)
          s1_x = p1.x - p0.x
          s1_y = p1.y - p0.y
          s2_x = p3.x - p2.x
          s2_y = p3.y - p2.y;

          d = (-s2_x * s1_y + s1_x * s2_y)

          s = (-s1_y * (p0.x - p2.x) + s1_x * (p0.y - p2.y)) / d;
          t = ( s2_x * (p0.y - p2.y) - s2_y * (p0.x - p2.x)) / d;

          if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
              x = p0.x + (t * s1_x)
              y = p0.y + (t * s1_y)

              V.new(x, y)
          else
            nil
          end
        end
      end
    end
  end
end