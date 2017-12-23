module Volt
  class World

    def update(dt)
      return if dt <= 0.0

      puts(dt)
    end
  end
end