module Volt
  module Structs
    ContactFaces = Struct.new(:reference, :incident)
    PointAlongAxis = Struct.new(:distance, :point)
    BroadContact = Struct.new(:body1, :body2)
  end
end