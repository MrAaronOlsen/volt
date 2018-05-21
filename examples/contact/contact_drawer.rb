class ContactExamples
  class ContactDrawer

    class << self
      def sketch(contact, scene)
        scene.add_effect(Canvas::Fade.new(contact_loc_sprite(contact), 10))
        scene.add_effect(Canvas::Fade.new(contact_normal_sprite(contact), 10))
      end

      def contact_loc_sprite(contact)
        Canvas::Sprite.new do |sprite|
          sprite.type = :circle
          sprite.center = contact.contact_loc
          sprite.radius = 10
          sprite.fill = true
          sprite.color = Canvas::Colors.yellow
          sprite.z = 1
        end
      end

      def contact_normal_sprite(contact)
        normal_start = contact.contact_loc
        normal_end = contact.contact_loc + ( contact.contact_normal * ( contact.penetration * 10 ) )

        Canvas::Sprite.new do |sprite|
          sprite.type = :line
          sprite.verts = [normal_start, normal_end]
          sprite.color = Canvas::Colors.red
          sprite.z = 1
        end
      end
    end
  end
end