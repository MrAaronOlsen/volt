module Canvas
  class Pencil
    class << self
      def circle(center, radius, color, fill, z = 1)
          axis1 = Vector.new(radius, 0)
      		axis2 = Vector.new(radius, 0)


      		60.times do
      			axis2.rotate(6)

            v1 = axis1 + center
            v2 = axis2 + center

            if fill
        			tri([v1, v2, center], color, true, z)
            else
              line([v1, v2], color, z )
            end

      			axis1.rotate(6)
      		end
      end

      def line(points, color, z = 1)

        Gosu.draw_line(
          points[0].x, points[0].y, color,
          points[1].x, points[1].y, color, z )
      end

      def tri(points, color, fill, z = 1)

        if fill
          Gosu.draw_triangle(
            points[0].x, points[0].y, color,
      		  points[1].x, points[1].y, color,
      		  points[2].x, points[2].y, color, z)
        else
          wire(points, color, z)
        end
      end

      def rect(points, color, fill, z = 1)

        if fill
          Gosu.draw_quad(
            points[0].x, points[0].y, color,
            points[1].x, points[1].y, color,
      			points[2].x, points[2].y, color,
      			points[3].x, points[3].y, color, z)
        else
          wire(points, color, z)
        end
      end

      def poly(points, center, color, fill, z = 1)
        points.push(points[0])

        points.each_with_index do |point, i|
          point2 = points[(i+1) % points.count]

          if fill
            tri([center, point, point2], color, true, z)
          else
            line([point, point2], color, z )
          end
        end
      end

      def wire(points, color, z = 1)
        points.push(points[0])

        points.each_with_index do |point, i|
          point2 = points[(i+1) % points.count]

          line([point, point2], color, z)
        end
      end
    end
  end
end