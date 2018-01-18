class Space
  attr_reader :ship, :world

  def initialize
    @world = World.new()
    @ship = Ship.new()

    @world.add_body(@ship.body)
  end

  def update(dt)
    move
    @world.update(dt)
  end

  def draw
    @ship.draw
  end

  def move
    @ship.go if Gosu::button_down?(Gosu::KbUp)
    @ship.stop if Gosu::button_down?(Gosu::KbDown)
    @ship.left if Gosu::button_down?(Gosu::KbLeft)
    @ship.right if Gosu::button_down?(Gosu::KbRight)
  end
end