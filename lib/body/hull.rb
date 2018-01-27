module Volt
  class Hull
    attr_reader :body, :verts, :count

    def initialize(body)
      @body = body
      @verts = wrap(all_verts)
      @count = @verts.count
    end

    def all_verts
      @body.shapes.reduce([]) do |verts, shape|
        verts += shape.verts
      end
    end

    def wrap(v)
      hull = []
      total = v.count
      o = 0

      loop do
        hull << v[o]
        b = (o + 1) % total

        v.each_with_index do |vert, a|
          b = a if determinant(v[o], v[a], v[b]) == 1
        end

        o = b
        break if o.zero?
      end

      hull
    end
  end
end