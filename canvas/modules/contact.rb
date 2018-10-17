module Canvas
  class Contact

    class << self
      def sketch(contact, scene)
        scene.add_effect(Canvas::Fade.new(contact_loc_sprite(contact), 5))
        scene.add_effect(Canvas::Fade.new(contact_normal_sprite(contact), 5))
        # scene.add_effect(Canvas::Fade.new(contact_face_sprite(contact), 10))
        # scene.add_effect(Canvas::Fade.new(body1_projection_normal_sprite(contact), 0))
        # scene.add_effect(Canvas::Fade.new(body2_projection_normal_sprite(contact), 0))
        # scene.add_effect(Canvas::Fade.new(reference_edge_sprite(contact), 0))
        # scene.add_effect(Canvas::Fade.new(incident_edge_sprite(contact), 0))
      end

      def contact_loc_sprite(manifold)
        Canvas::Sprite.new do |sprite|
          sprite.type = :circle
          sprite.center = manifold.body1_contact_loc
          sprite.radius = 10
          sprite.fill = true
          sprite.color = Canvas::Colors.yellow
          sprite.z = 1
        end
      end

      def contact_normal_sprite(manifold)
        normal_start = manifold.body1_contact_loc
        normal_end = manifold.body1_contact_loc - ( manifold.contact_normal * ( manifold.penetration * 10 ) )

        Canvas::Sprite.new do |sprite|
          sprite.type = :line
          sprite.verts = [normal_start, normal_end]
          sprite.color = Canvas::Colors.red
          sprite.z = 1
        end
      end

      def contact_face_sprite(manifold)
        Canvas::Sprite.new do |sprite|
          sprite.type = :line
          sprite.verts = [manifold.contact_face.from, manifold.contact_face.to]
          sprite.color = Canvas::Colors.green
          sprite.z = 1
        end
      end

      def body1_projection_normal_sprite(contact)
        line_start = V.new(contact.body1_norm_proj.min, 55)
        line_end = V.new(contact.body1_norm_proj.max, 55)

        Canvas::Sprite.new do |sprite|
          sprite.type = :line
          sprite.verts = [line_start, line_end]
          sprite.color = Canvas::Colors.green
          sprite.z = 1
        end
      end

      def body2_projection_normal_sprite(contact)
        line_start = V.new(contact.body2_norm_proj.min, 50)
        line_end = V.new(contact.body2_norm_proj.max, 50)

        Canvas::Sprite.new do |sprite|
          sprite.type = :line
          sprite.verts = [line_start, line_end]
          sprite.color = Canvas::Colors.red
          sprite.z = 1
        end
      end

      def reference_edge_sprite(contact)
        line_start = contact.reference_face.from
        line_end = contact.reference_face.to

        Canvas::Sprite.new do |sprite|
          sprite.type = :line
          sprite.verts = [line_start, line_end]
          sprite.color = Canvas::Colors.orange
          sprite.z = 1
        end
      end

      def incident_edge_sprite(contact)
        line_start = contact.incident_face.from
        line_end = contact.incident_face.to

        Canvas::Sprite.new do |sprite|
          sprite.type = :line
          sprite.verts = [line_start, line_end]
          sprite.color = Canvas::Colors.green
          sprite.z = 1
        end
      end
    end
  end
end