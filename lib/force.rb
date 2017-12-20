require 'vector.rb'

module Volt
  class Force
    attr_reader :energy

    def addForce(force)
      energy.add(force)
    end

    def clear
      energy.zero
    end
  end
end