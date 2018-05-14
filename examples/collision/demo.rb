require './volt.rb'
require_relative 'space.rb'
require_relative 'scene.rb'
require_relative 'ball.rb'
require_relative 'blob.rb'
require_relative 'wall.rb'
require_relative 'box.rb'
require_relative 'poly.rb'
require_relative 'line.rb'

class Window < Gosu::Window

	def initialize
    $window_width = 1200
    $window_height = 1200

    super($window_width, $window_height, false)
    self.caption = "Ship Demo"
		
    @space = Space.new
		@time_step = 1.0/60.0
 	end

	def update
    @space.update(@time_step)
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