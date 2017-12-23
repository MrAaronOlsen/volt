require 'simplecov'
SimpleCov.start do
  add_filter "spec/"
end

require 'pry'

require './volt.rb'
include Volt

require './lib/vector.rb'
require './lib/body.rb'