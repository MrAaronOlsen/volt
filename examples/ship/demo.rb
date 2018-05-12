require_relative '../example.rb'
require_relative 'space.rb'
require_relative 'wall.rb'
require_relative 'ship.rb'
require_relative 'scene.rb'

class Window < Gosu::Window

	def initialize
    $window_width = 1200
    $window_height = 1200

    super($window_width, $window_height, false)
    self.caption = "Ship Demo"

    @space = Space.new
 	end

	def update
    @space.update(1.0/60.0)
  end

	def draw
		@space.draw
	end

	def button_down(button)
		close if button == Gosu::KbEscape

		@space.button_down?(button)
  end
end

Window.new.show