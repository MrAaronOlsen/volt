class Space
  attr_reader :world, :player, :drawer, :scene

  def initialize
    @world = World.new
    @scene = Scene.new(@world)
    @drawer = Canvas::Drawer.new(debug: $debug)

    @bodies = Wall.get_walls
    @player = Player.new(V.new(700, 900), -90, @scene)
    @bodies << @player.body

    ball = Ball.new(V.new(900, 900)).body
    @bodies << ball

    @joints = []
    @joints << Joints::Cable.new(@player.body, ball, 400, 0.8)

    @world.add_bodies(@bodies)
    @world.add_joints(@joints)

    @pause = false
  end

  def update(dt)
    @scene.reset

    move_player?
    @world.update(@pause ? 0 : dt)
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