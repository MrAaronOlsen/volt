class Scene
  attr_reader :world, :contacts

  def initialize(world)
    @world = world
    @contacts = Array.new
  end

  def reset
    @contacts = Array.new
  end
end