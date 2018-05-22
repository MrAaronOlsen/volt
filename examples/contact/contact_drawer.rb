class ContactExamples
  class ContactDrawer

    class << self
      def sketch(contact, scene)
        scene.add_effect(Canvas::Fade.new(contact_loc_sprite(contact), 10))
        scene.add_effect(Canvas::Fade.new(contact_normal_sprite(contact),10))
        scene.add_effect(Canvas::Fade.new(contact_face_sprite(contact), 10))
        # scene.add_effect(Canvas::Fade.new(body_projection_sprite(contact), 0))
        # scene.add_effect(Canvas::Fade.new(line_projection_sprite(contact), 0))
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

      def contact_face_sprite(contact)
        Canvas::Sprite.new do |sprite|
          sprite.type = :line
          sprite.verts = [contact.contact_face.start, contact.contact_face.end]
          sprite.color = Canvas::Colors.green
          sprite.z = 1
        end
      end

      def body_projection_sprite(contact)
        line_start = V.new(contact.body1_minmax.min.abs, 50)
        line_end = V.new(contact.body1_minmax.max.abs, 50)

        Canvas::Sprite.new do |sprite|
          sprite.type = :line
          sprite.verts = [line_start, line_end]
          sprite.color = Canvas::Colors.green
          sprite.z = 1
        end
      end

      def line_projection_sprite(contact)
        line_start = V.new(contact.body2_minmax.min.abs, 50)
        line_end = V.new(contact.body2_minmax.max.abs + 1, 50)

        Canvas::Sprite.new do |sprite|
          sprite.type = :line
          sprite.verts = [line_start, line_end]
          sprite.color = Canvas::Colors.red
          sprite.z = 1
        end
      end
    end
  end
end