require 'gosu'
require 'pry-nav'
require 'colorize'

Dir["./lib/core/*.rb"].each { |file| require file }
Dir["./lib/shapes/*.rb"].each { |file| require file }
Dir["./lib/body/**/*.rb"].each { |file| require file }
Dir["./lib/contact/**/*.rb"].each { |file| require file }
Dir["./lib/joints/*.rb"].each { |file| require file }
Dir["./lib/*.rb"].each { |file| require file }

include Volt
include Structs