module Volt
  module Collision
    class Contact
      attr_reader :manifold, :body1, :body2
      attr_accessor :dummy

      def initialize(manifold)
        @manifold = manifold
        @dummy = false

        yield self if block_given?
      end

      def add_bodies(body1, body2)
        @body1, @body2 = body1, body2
      end

      def contact_loc
        @manifold.contact_loc
      end

      def contact_normal
        @manifold.contact_normal
      end

      def penetration
        @manifold.penetration
      end

      def restitution
        @manifold.restitution
      end

      def is_joint
        @manifold.is_joint
      end

      def resolve(dt)
        [@body1, @body2].each { |body| body.run_callbacks(:pre, self) }
        return if @dummy

        resolve_interpenetration(dt)
        resolve_velocity(dt)

        [@body1, @body2].each { |body| body.run_callbacks(:post, self) }
      end

      def get_seperating_velocity
        rel_velocity = @body1.vel.copy
        rel_velocity.sub(@body2.vel) if @body2

        rel_velocity.dot(contact_normal)
      end

      private

      def resolve_interpenetration(dt)
        if penetration <= 0
          return
        end

        movement = Array.new(2)

        total_i_mass = @body1.i_mass
        if @body2
          total_i_mass += @body2.i_mass
        end

        if total_i_mass <= 0
          return
        end

        move_per_i_mass = contact_normal * (penetration / total_i_mass)
        movement[0] = move_per_i_mass * @body1.i_mass

        if @body2
          movement[1] = move_per_i_mass * -@body2.i_mass
        end

        @body1.pos.add(movement[0])

        if @body2
          @body2.pos.add(movement[1])
        end
      end

      def resolve_velocity(dt)
        seperating_velocity = get_seperating_velocity

        if seperating_velocity > 0.0
          return
        end

        new_sep_velocity = -seperating_velocity * restitution
        velocity_buildup = @body1.acc.copy

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

        is_joint ? point = @manifold.body1_contact_loc : point = contact_loc
        @body1.add_impulse_at(impulse_per_i_mass * @body1.i_mass, point)

        if @body2
          is_joint ? point = @manifold.body2_contact_loc : point = contact_loc
          @body2.add_impulse_at(impulse_per_i_mass * -@body2.i_mass, point)
        end
      end
    end
  end
end