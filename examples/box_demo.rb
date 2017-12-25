require_relative 'example.rb'

class BoxWorld

	def initialize
		@world = World.new
		@box_body = BoxBody.new
		@box = Box.new(30, 30)
		@box.set_body(@box_body)

		@world.add_body(@box_body)
	end

	def update(dt)
		@world.update(dt)
	end

	def draw
		Draw.rect(@box.points, 0xff_00ff00)
	end
end

class BoxBody < Body
	def initialize
		super do |b|
			b.config(
				pos: V.new(600, 600)
			)
		end
	end
end

class Window < Gosu::Window

	def initialize
    $window_width = 1200
    $window_height = 1200

    super($window_width, $window_height, false)
    self.caption = "Base Window"

    @world = BoxWorld.new
    @time = TimeStep.new
 	end

	def update
    @world.update(@time.get_dt)
  end

	def draw
		@world.draw
	end

	def button_down(id)
    close if id == Gosu::KbEscape
  end
end

Window.new.show