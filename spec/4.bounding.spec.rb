require "benchmark"
require "./volt"


verts = [
  V.new(10, 8).with_name("A"),
  V.new(11, 13).with_name("B"),
  V.new(2, 10).with_name("C"),
  V.new(10, 4).with_name("D"),
  V.new(10, 15).with_name("E"),
  V.new(13, 8).with_name("F"),
  V.new(15, 10).with_name("G"),
  V.new(5, 5).with_name("H"),
  V.new(5, 9).with_name("I"),
  V.new(8, 5).with_name("J")
]

hull = Hull.new(verts)

# Benchmark.bm do |x|
#   x.report { BroadPhase::Bounding.new(hull.verts) }
# end
#
# Benchmark.bm do |x|
#   x.report { BroadPhase::BoundingOld.new(verts) }
# end
bounding = BroadPhase::Bounding.new(hull.verts)

# puts "Old: #{BroadPhase::BoundingOld.new(verts)}"