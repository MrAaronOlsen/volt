class Scene
  attr_reader :world, :contacts, :effects

  def initialize(world)
    @world = world

    @contacts = Array.new
    @effects = Array.new
  end

  def reset
    @contacts = Array.new
    @effects.delete_if { |effect| effect.dead }
  end

  def add_effect(effect)
    @effects.shift if @effects.size > 10
    @effects << effect
  end
end