module Volt
  module Collision
    class Contact
      attr_reader :body1, :body2
      attr_reader :shape1, :shape2
      attr_accessor :contact_normal, :contact_loc
      attr_accessor :restitution, :penetration, :movement
      attr_accessor :handler, :dummy

      def initialize(body1, body2)
        @body1, @body2 = body1, body2
        @restitution = 0.98
        @dummy = false
      end

      def add_shapes(shape1, shape2)
        @shape1 = shape1
        @shape2 = shape2
      end

      def resolve(dt)
        return if @dummy

        resolve_interpenetration(dt)
        resolve_velocity(dt)
      end

      def get_seperating_velocity
        rel_velocity = @body1.vel.copy
        rel_velocity.sub(@body2.vel) if @body2

        rel_velocity.dot(contact_normal)
      end

      def is_dummy
        @dummy = true
      end

      def debug
        @handler.debug
      end

      private

      def resolve_interpenetration(dt)
        if penetration <= 0
          return
        end

        @movement = Array.new(2)

        total_i_mass = @body1.i_mass
        if @body2
          total_i_mass += @body2.i_mass
        end

        if total_i_mass <= 0
          return
        end

        move_per_i_mass = contact_normal * (penetration / total_i_mass)
        @movement[0] = move_per_i_mass * @body1.i_mass

        if @body2
          @movement[1] = move_per_i_mass * -@body2.i_mass
        end

        @body1.pos.add(@movement[0])

        if @body2
          @body2.pos.add(@movement[1])
        end
      end

      def resolve_velocity(dt)
        seperating_velocity = get_seperating_velocity

        if seperating_velocity > 0.0
          return
        end

        new_sep_velocity = -seperating_velocity * restitution
        velocity_buildup = @body1.vel.copy

        if @body2
          velocity_buildup.sub(@body2.acc)
        end

        buildup_sep_vel = velocity_buildup.dot(contact_normal * dt)

        if buildup_sep_vel < 0
          new_sep_velocity += (buildup_sep_vel * restitution)

          if new_sep_velocity < 0
            new_sep_velocity = 0
          end
        end

        delta_velocity = new_sep_velocity - seperating_velocity

        total_i_mass = @body1.i_mass
        total_i_mass += @body2.i_mass if @body2

        if total_i_mass <= 0.0
          return
        end

        impulse = delta_velocity / total_i_mass
        impulse_per_i_mass = contact_normal * impulse

        @body1.add_impulse_at(impulse_per_i_mass * @body1.i_mass, @contact_loc)

        if @body2
          @body2.add_impulse_at(impulse_per_i_mass * -@body2.i_mass, @contact_loc)
        end
      end
    end
  end
end