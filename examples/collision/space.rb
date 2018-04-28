class Space
  attr_reader :ships, :player, :world, :drawer

  def initialize
    @world = World.new
    @drawer = Canvas::Drawer.new(debug: true)

    @player = Ball.new(V.new(600, 200))
    @blob = Blob.new(V.new(1200, 600))
    @wall = Wall.new(V.new(100, 100))

    @world.add_bodies([@player.body, @wall.body])
  end

  def update(dt)
    move_player?
    @world.update(dt)
  end

  def draw
    @drawer.render(@world.bodies)
    @world.debug
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