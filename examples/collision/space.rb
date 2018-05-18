class Space
  attr_reader :world, :player, :drawer, :scene

  def initialize
    @world = World.new
    @scene = Scene.new(@world)
    @drawer = Canvas::Drawer.new(debug: true)

    @bodies = []

    @bodies << Wall.new(V.new(50, 50), 0).body
    @bodies << Wall.new(V.new(50, 50), -90).body
    @bodies << Wall.new(V.new(1150, 50), 0).body
    @bodies << Wall.new(V.new(1150, 1150), 90).body

    # @bodies << Ball.new(V.new(900, 900)).body
    # @bodies << Blob.new(V.new(600, 300)).body
    # @bodies << Line.new(V.new(200, 400), 200).body
    # @bodies << Box.new(V.new(200, 900)).body
    # @bodies << Poly.new(V.new(700, 900), 160).body

    @player = Poly.new(V.new(600, 600), -90)

    @player.body.add_callback_block(:post) do |body, contact|
      @scene.contacts << contact
    end

    @bodies << @player.body

    @world.add_bodies(@bodies)

    @pause = false
  end

  def update(dt)
    return if @pause
    @scene.reset

    move_player?
    @world.update(dt)
  end

  def draw
    @drawer.render(@scene)
  end

  def button_down?(id)
    @drawer.flip_debug if id == Gosu::KbD
    @pause = !@pause if id == Gosu::KbSpace
  end

  def move_player?
    @player.go if Gosu.button_down?(Gosu::KbUp)
    @player.stop if Gosu.button_down?(Gosu::KbDown)
    @player.left if Gosu.button_down?(Gosu::KbLeft)
    @player.right if Gosu.button_down?(Gosu::KbRight)
  end
end