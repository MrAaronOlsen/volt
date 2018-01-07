require "pry"

class ClassThing

  def initialize()
    @functions = {}
  end

  def add_function(symbol, &block)
    @functions[symbol] = block
  end

  def run_functions(*symbols)
    symbols.each do |symbol|
      @functions[symbol].call
    end
  end

end

class Person
  attr_accessor :age

  def initialize(name)
    @name = name
    @age = 0
  end

  def display_person
    print "Hello! My name is " + @name + " and I am " + @age.to_s + " years old!\n"
  end

end

person = Person.new("Aaron")

class_thing = ClassThing.new

class_thing.add_function(:person) do
  person.age = 35
  person.display_person
end

class_thing.run_functions(:person)