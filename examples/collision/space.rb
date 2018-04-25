class Space
  attr_reader :ships, :player, :world, :drawer

  def initialize
    @world = World.new

    @player = Ball.new(V.new(600, 600))
    @static = Ball.new(V.new(100, 600))

    @world.add_bodies([@player.body, @static.body])
    @drawer = Canvas::Drawer.new(debug: true)
  end

  def update(dt)
    move_player?
    @world.update(dt)
  end

  def draw
    @drawer.render(@world.bodies)
  end

  def button_down?(id)
    @drawer.flip_debug if id == Gosu::KbD
  end

  def move_player?
    @player.go if Gosu.button_down?(Gosu::KbUp)
    @player.stop if Gosu.button_down?(Gosu::KbDown)
    @player.left if Gosu.button_down?(Gosu::KbLeft)
    @player.right if Gosu.button_down?(Gosu::KbRight)
  end
end