require 'simplecov'
SimpleCov.start do
  add_filter "spec/"
end

require 'rspec'
require 'pry'

require './volt.rb'
include Volt

require_relative 'test_body.rb'