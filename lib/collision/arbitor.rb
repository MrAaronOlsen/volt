module Volt
  module Collision
    class Arbitor
      include Structs
      attr_reader :broad_contacts, :narrow_contacts, :joint_contacts

      def query(bodies, joints)
        @broad_contacts = []
        @narrow_contacts = []
        @joint_contacts = []

        collect_broad_contacts(bodies)
        collect_narrow_contacts
        collect_joint_contacts(joints)
      end

      def clear
        @broad_contacts = []
        @narrow_contacts = []
        @joint_contacts = []
      end

      def resolve(dt)
        sorted_contacts = @narrow_contacts.sort_by { |contact| contact.penetration }
        sorted_contacts.each { |contact| contact.resolve(dt) }

        sorted_constraints = @joint_contacts.sort_by { |contact| contact.penetration }
        sorted_constraints.each { |contact| contact.resolve(dt) }
      end

      def collect_broad_contacts(bodies)
        bodies.each_with_index do |body1, i|
          bodies[i+1..-1].each do |body2|
            @broad_contacts << BroadContact.new(body1, body2) if AABB.query(body1.bounding, body2.bounding)
          end
        end
      end

      def collect_narrow_contacts
        @broad_contacts.each do |contact|
          contact.body1.shapes.each do |shape1|
            next if shape1.static

            contact.body2.shapes.each do |shape2|
              next if shape2.static

              handler = Dispatch.find_handler(shape1, shape2)

              if handler.exists? && handler.query
                @narrow_contacts << handler.get_contact
              end
            end
          end
        end
      end

      def collect_joint_contacts(joints)
        joints.each do |joint|
          @joint_contacts << joint.get_contact if joint.query
        end
      end
    end
  end
end