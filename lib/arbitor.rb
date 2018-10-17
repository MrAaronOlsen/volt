module Volt
  class Arbitor
    include Structs
    attr_reader :broad_contacts, :contact_manifolds, :joint_contacts

    def query(bodies, joints)
      @broad_contacts = []
      @contact_manifolds = []
      @joint_contacts = []

      collect_broad_contacts(bodies)
      collect_contact_manifolds
      collect_joint_contacts(joints)
    end

    def reset
      @broad_contacts = []
      @contact_manifolds = []
      @joint_contacts = []
    end

    def resolve(dt)
      sorted_contacts = @contact_manifolds.sort_by { |manifold| manifold.penetration }
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

    def collect_contact_manifolds
      @broad_contacts.each do |contact|
        contact.body1.shapes.each do |shape1|
          next if shape1.static

          contact.body2.shapes.each do |shape2|
            next if shape2.static

            handler = Contact::Dispatch.find_handler(shape1, shape2)

            if handler.exists? && handler.query
              @contact_manifolds << handler.manifold
            end
          end
        end
      end
    end

    def collect_joint_contacts(joints)
      joints.each do |joint|
        @joint_contacts << joint.manifold if joint.query
      end
    end
  end
end