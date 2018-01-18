class Draw

  class << self

    def line(a, b, color, z = 1)
      Gosu.draw_line(
        a.x, a.y, color,
        b.x, b.y, color, z )
    end

    def tri(points, color, z = 1)
      Gosu.draw_triangle(
        points[0].x, points[0].y, color,
			  points[1].x, points[1].y, color,
			  points[2].x, points[2].y, color, z)
    end

    def rect(points, color, z = 1)
      Gosu.draw_quad(
        points[0].x, points[0].y, color,
        points[1].x, points[1].y, color,
				points[2].x, points[2].y, color,
				points[3].x, points[3].y, color, z)
    end

    def poly(points, center, color, z = 1)
      points.push(points[0])

      points.each_with_index do |point, i|
        point2 = points[(i+1) % points.count]

        Gosu.draw_triangle(
          center.x, center.y, color,
          point.x, point.y, color,
          point2.x, point2.y, color, z)
      end
    end

    def circle_full(center, radius, color, z = 1)
      axis1 = Vector.new(radius, 0)
			axis2 = Vector.new(radius, 0)

			60.times do
				axis2.rotate(6)

				x1 = axis1.x + center.x
				y1 = axis1.y + center.y
				x2 = axis2.x + center.x
				y2 = axis2.y + center.y

				Gosu.draw_triangle( center.x, center.y, color, x1, y1, color, x2, y2, color, z )

				axis1.rotate(6)
			end
    end

    def circle_empty(center, radius, color, z = 1)
      axis1 = Vector.new(radius, 0)
			axis2 = Vector.new(radius, 0)

			60.times do
				axis2.rotate(6)

				x1 = axis1.x + center.x
				y1 = axis1.y + center.y
				x2 = axis2.x + center.x
				y2 = axis2.y + center.y

				Draw.line( V.new(x1, y1), V.new(x2, y2), color, z )

				axis1.rotate(6)
			end
    end

    def colors
      {
        "red": 0xff_ff0000,
        "yellow": 0xff_ffff00,
        "green": 0xff_00ff00,
        "magenta": 0xff_00ffff,
        "blue": 0xff_0000ff,
        "purple": 0xff_ff00ff,
        "white": 0xff_ffffff
      }
    end
  end

end