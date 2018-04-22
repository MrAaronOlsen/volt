require 'gosu'
require 'pry'
require 'colorize'

Dir["./lib/core/*.rb"].each { |file| require file }
Dir["./lib/collision/*.rb"].each { |file| require file }
Dir["./lib/shapes/*.rb"].each { |file| require file }
Dir["./lib/body/*.rb"].each { |file| require file }
Dir["./lib/*.rb"].each { |file| require file }

Dir["./canvas/*.rb"].each { |file| require file }

include Volt