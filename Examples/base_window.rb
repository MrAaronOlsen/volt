class Window < Gosu::Window

	def initialize
    $window_width = 1200
    $window_height = 1200

    super($window_width, $window_height, false)
    self.caption = "Base Window"

		@time_step = 1.0/60.0
 	end

	def update
  end

	def draw
	end

	def button_down(id)
    close if id == Gosu::KbEscape
  end
end

Window.new.show