require_relative 'example.rb'

class Window < Gosu::Window

	def initialize
    $window_width = 1200
    $window_height = 1200

    super($window_width, $window_height, false)
    self.caption = "Base Window"

    @world = World.new
    @time = TimeStep.new
 	end

	def update
    @world.update(@time.get_dt)
  end

	def draw
	end

	def button_down(id)
    close if id == Gosu::KbEscape
  end
end

Window.new.show