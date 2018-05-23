class ContactExamples
  class Space
    attr_reader :world, :player, :drawer, :scene

    def initialize
      @world = World.new
      @scene = Scene.new(@world)
      @drawer = Canvas::Drawer.new(debug: false)

      @bodies = Wall.get_walls
      @bodies << Line.new(V.new(850, 600), 300, 170).body

      @player = Player.new(V.new(200, 590), -90, @scene)
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
      @player.freeze if Gosu.button_down?(Gosu::KbP)
    end
  end
end