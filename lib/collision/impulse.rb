module Volt
  module Collision
    class Impulse
      class << self

        def resolve_velocity(contact, dt)
          body1 = contact.body1
          body2 = contact.body2

          contact_normal = contact.contact_normal.unit
          contact_loc = contact.contact_loc
          restitution = 0.5

          manifold = contact.manifold
          is_joint = contact.is_joint

          rel_velocity = body1.vel.copy
          rel_velocity.sub(body2.vel)
          seperating_velocity = rel_velocity.dot(contact_normal)

          return if seperating_velocity > 0.0

          new_sep_velocity = -seperating_velocity * restitution
          velocity_buildup = body1.acc.copy

          velocity_buildup.sub(body2.acc)

          buildup_sep_vel = velocity_buildup.dot(contact_normal * dt)

          if buildup_sep_vel < 0
            new_sep_velocity += (buildup_sep_vel * restitution)

            new_sep_velocity = 0 if new_sep_velocity < 0
          end

          delta_velocity = new_sep_velocity - seperating_velocity

          total_i_mass = body1.i_mass
          total_i_mass += body2.i_mass

          return if total_i_mass <= 0.0

          impulse = delta_velocity / total_i_mass
          impulse_per_i_mass = contact_normal * impulse

          is_joint ? point = manifold.body1_contact_loc : point = contact_loc
          body1.add_lin_impulse(impulse_per_i_mass)
          body1.add_rot_impulse(impulse_per_i_mass * body1.i_mass, point)

          is_joint ? point = manifold.body2_contact_loc : point = contact_loc
          body2.add_lin_impulse(impulse_per_i_mass * -1)
          body2.add_rot_impulse(impulse_per_i_mass * -body2.i_mass, point)
        end

        def resolve_interpenetration(contact, dt)
          body1 = contact.body1
          body2 = contact.body2

          contact_normal = contact.contact_normal.unit
          penetration = contact.penetration

          return if penetration <= 0.1

          total_i_mass = body1.i_mass
          total_i_mass += body2.i_mass

          return if total_i_mass <= 0

          move_per_i_mass = contact_normal * (penetration / total_i_mass)

          body1.pos.add(move_per_i_mass * body1.i_mass)
          body2.pos.add(move_per_i_mass * -body2.i_mass)
        end
      end
    end
  end
end