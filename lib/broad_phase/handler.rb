module Volt
  class BroadPhase
    class Handler

      def query(bodies)
        i = 0

        until i == bodies.count
          j = i + 1

          while j < bodies.count
            puts "Checking #{i} and #{j} out of #{bodies.count}"

            if collide?(bodies[i], bodies[j])
              puts "Collide!!!"
            end
            j += 1
          end

          i += 1
        end
      end

      def collide?(body1, body2)
        center1 = body1.trans.transform_vert(body1.bounding.circle.center)
        radius1 = body1.bounding.circle.radius
        center2 = body2.trans.transform_vert(body2.bounding.circle.center)
        radius2 = body2.bounding.circle.radius

        puts "Center 1 = #{center1}"
        puts "Center 2 = #{center2}"

        distance = (center1 - center2).mag

        puts "Distance: #{distance}"
        if (distance / 2) < radius1 || (distance / 2) < radius2
          true
        else
          false
        end
      end
    end
  end
end