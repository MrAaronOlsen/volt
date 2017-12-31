require_relative 'example.rb'

class BoxWorld
	attr_reader :box_body

	def initialize
		@world = World.new
		@box_body = BoxBody.new
		@box_body.add_force(V.new(100, 0))
		@box = Box.new(100, 100)
		@box.set_body(@box_body)

		@world.add_body(@box_body)
	end

	def update(dt)
		@world.update(dt)
	end

	def draw
		Draw.rect(@box.get_world_verts, 0xff_00ff00)
		Draw.circle(@box.get_world_centroid, 10, 0xff_0000ff)
		Draw.circle(@box_body.pos, 10, 0xff_ff0000)
	end
end

class BoxBody < Body
	def initialize
		super do |b|
			b.config(
				pos: V.new(0, 600),
				vel: V.new(0, 0),
				damp: 0.99,
				mass: 1
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
    @world.update(0.16)
  end

	def draw
		@world.draw
	end

	def button_down(id)
    close if id == Gosu::KbEscape
		@world.box_body.add_force(Vect.new(100, 0)) if id == Gosu::KbRight
		@world.box_body.add_force(Vect.new(-100, 0)) if id == Gosu::KbLeft
		@world.box_body.add_force(Vect.new(0, -100)) if id == Gosu::KbUp
		@world.box_body.add_force(Vect.new(0, 100)) if id == Gosu::KbDown
  end
end

Window.new.show