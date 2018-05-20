class ContactExamples
  class Space
    attr_reader :world, :player, :drawer, :scene

    def initialize
      @world = World.new
      @scene = Scene.new(@world)
      @drawer = Canvas::Drawer.new(debug: true)

      @bodies = Wall.get_walls
      @player = Player.new(V.new(600, 600), -90, @scene)
      @bodies << @player.body

      @world.add_bodies(@bodies)
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
      @drawer.toggle_debug if id == Gosu::KbD
      @pause = !@pause if id == Gosu::KbSpace
    end

    def move_player?
      @player.go if Gosu.button_down?(Gosu::KbUp)
      @player.stop if Gosu.button_down?(Gosu::KbDown)
      @player.left if Gosu.button_down?(Gosu::KbLeft)
      @player.right if Gosu.button_down?(Gosu::KbRight)
    end
  end
end