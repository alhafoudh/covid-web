module ApplicationHelper
  def image_srcset_tag(source, options = {})
    image_tag(
      source,
      {
        srcset: [
          srcset_variant(source, '2x'),
          srcset_variant(source, '3x'),
        ].reduce({}, :merge)
      }.merge(options)
    )
  end

  def srcset_variant(source, variant)
    base_name = File.basename(source, '.*')
    ext_name = File.extname(source)
    { "#{base_name}@#{variant}#{ext_name}" => variant }
  end
end
