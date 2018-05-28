class ContactExamples
  class Space
    attr_reader :world, :player, :drawer, :scene

    def initialize
      @world = World.new
      @scene = Scene.new(@world)
      @drawer = Canvas::Drawer.new(debug: false)

      @bodies = Array.new
      # @bodies = Wall.get_walls
      @bodies << Poly.new(V.new(700, 600), 0).body
      @player = Player.new(V.new(500, 600), -90, @scene)
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
      $debug = !$debug if Gosu.button_down?(Gosu::KbR)
      @drawer.toggle_debug if id == Gosu::KbD
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
end