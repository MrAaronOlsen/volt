class Space
  attr_reader :ship, :world, :drawer

  def initialize
    @world = World.new

    @ships = [
      Ship.new(V.new(600, 600)),
      Ship.new(V.new(100, 600)),
      Ship.new(V.new(900, 200))
    ]

    @bodies = @ships.map { |ship| ship.body }

    @world.add_bodies(@bodies)
    @drawer = Canvas::Drawer.new
  end

  def update(dt)
    move?
    @world.update(dt)
  end

  def draw
    @drawer.render(@world.bodies)
  end

  def move?
    @ships[0].go if Gosu::button_down?(Gosu::KbUp)
    @ships[0].stop if Gosu::button_down?(Gosu::KbDown)
    @ships[0].left if Gosu::button_down?(Gosu::KbLeft)
    @ships[0].right if Gosu::button_down?(Gosu::KbRight)
  end
end