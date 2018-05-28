class Space
  attr_reader :ships, :player, :world, :drawer

  def initialize
    @world = World.new
    @scene = Scene.new(@world)
    @drawer = Canvas::Drawer.new(debug: $debug)
    @bodies = []

    @bodies << Wall.new(V.new(50, 50), 0).body
    @bodies << Wall.new(V.new(50, 50), -90).body
    @bodies << Wall.new(V.new(1150, 50), 0).body
    @bodies << Wall.new(V.new(1150, 1150), 90).body

    @bodies << Ship.new(V.new(200, 900)).body
    @bodies << Ship.new(V.new(900, 200)).body

    @player = Ship.new(V.new(600, 600))
    @player.body.scale(3, 3)

    @bodies << @player.body

    @world.add_bodies(@bodies)
  end

  def update(dt)
    move_player?
    @world.update(dt)
  end

  def draw
    @drawer.render(@scene)
  end

  def button_down?(id)
    $debug = !$debug if Gosu.button_down?(Gosu::KbR)
    @drawer.toggle_debug if Gosu.button_down?(Gosu::KbD)

    @pause = !@pause if id == Gosu::KbP
  end

  def move_player?
    @player.go if Gosu.button_down?(Gosu::KbUp)
    @player.stop if Gosu.button_down?(Gosu::KbDown)
    @player.left if Gosu.button_down?(Gosu::KbLeft)
    @player.right if Gosu.button_down?(Gosu::KbRight)
    @player.freeze if Gosu.button_down?(Gosu::KbSpace)
  end
end