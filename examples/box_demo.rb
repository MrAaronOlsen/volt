require_relative 'example.rb'

class BoxWorld
	attr_reader :box_body, :box

	def initialize
		@world = World.new
		@box_body = BoxBody.new
		@box = Box.new(100, 100, V.new(-50, -50), 10)
		@box.set_body(@box_body)

		@world.add_body(@box_body)
	end

	def update(dt)
		@world.update(dt)
	end

	def draw
		Draw.rect(@box.world_verts, 0xff_999999)
		Draw.circle_full(@box.world_centroid, 5, 0xff_0000ff)
		Draw.circle_empty(@box_body.pos, 10, 0xff_ff0000)
		Draw.circle_empty(@box_body.cog, 15, 0xff_ffff00)
		Draw.circle_full(@box.world_verts[0], 5, 0xff_00ffff)
	end
end

class BoxBody < Body
	def initialize
		super do |b|
			b.pos = V.new(600, 600)
			b.damp = 0.98
			b.mass = 10
			b.moment = 10
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
    @world.update(1.0/60.0)
  end

	def draw
		@world.draw
	end

	def button_down(id)
		box = @world.box
    close if id == Gosu::KbEscape

		@world.box_body.add_force(Vect.new(10000, 0)) if id == Gosu::KbD
		@world.box_body.add_force(Vect.new(-10000, 0)) if id == Gosu::KbA
		@world.box_body.add_force(Vect.new(0, -10000)) if id == Gosu::KbW
		@world.box_body.add_force(Vect.new(0, 10000)) if id == Gosu::KbS

		@world.box_body.add_force_at(Vect.new(100, 0), box.world_verts[0]) if id == Gosu::KbRight
		@world.box_body.add_force_at(Vect.new(-100, 0), box.world_verts[0]) if id == Gosu::KbLeft
		@world.box_body.add_force_at(Vect.new(0, -100), box.world_verts[0]) if id == Gosu::KbUp
		@world.box_body.add_force_at(Vect.new(0, 100), box.world_verts[0]) if id == Gosu::KbDown
  end
end

Window.new.show