module Volt
  class AABB
    attr_reader :body, :left, :right, :top, :bot, :center

    def initialize(body)
      @body = body
    end

    def update
      verts = @body.world_positions(@body.hull.verts)
      center = @body.world_position(@body.cog)

      xs = verts.minmax_by { |vert| vert.x }
      ys = verts.minmax_by { |vert| vert.y }

      @left, @right = xs[0], xs[1]
      @top, @bot = ys[0], ys[1]
    end

    def corners
      [ V.new(@left.x, @top.y), V.new(@right.x, @top.y),
        V.new(@right.x, @bot.y), V.new(@left.x, @bot.y) ]
    end

    class << self
      def query(box1, box2)
        box1.update
        box2.update

        rl = box1.right.x < box2.left.x
        lr = box1.left.x > box2.right.x
        bt = box1.bot.y < box2.top.y
        tb = box1.top.y > box2.bot.y

        !(rl || lr || bt || tb)
      end
    end
  end
end