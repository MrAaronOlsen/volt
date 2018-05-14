module Volt
  class Bounding
    attr_reader :type

    class TempBall
      attr_reader :center, :radius

      def initialize(center, radius)
        @center, @radius = center, radius
      end

      def contains_points(points)
        points.all do |point|
          contains_point(point)
        end
      end

      def contains_point(point)
        @center.distance_to(point) <= @radius * (1 + 1e-14)
      end
    end

    class TempBox
      def initialize(ball)
        @ball = ball
        @center, @radius = ball.center, ball.radius
      end

      def left
        V.new(@center.x - @radius, 0)
      end

      def right
        V.new(@center.x + @radius, 0)
      end

      def top
        V.new(0, @center.y - @radius)
      end

      def bot
        V.new(0, @center.y + @radius)
      end

      def world_position(vert)
        @ball.world_position(vert)
      end
    end

    def box_box_query(box1, box2)
      box1.world_position(box1.right).x < box2.world_position(box2.left).x ||
      box1.world_position(box1.left).x > box2.world_position(box2.right).x ||
      box1.world_position(box1.bot).y < box2.world_position(box2.top).y ||
      box1.world_position(box1.top).y > box2.world_position(box2.bot).y
    end

    def ball_ball_query(ball1, ball2)
      center1 = ball1.world_position(ball1.center)
      center2 = ball2.world_position(ball2.center)

      distance = center1.distance_to(center2)
      (ball1.radius + ball2.radius) - distance > 0
    end

    def box_ball_query(box, ball)
      box_box_query(box, TempBox.new(ball))
    end
  end
end