module Testing
  module MetaTagsHelper
    def meta_title
      content_for?(:meta_title) ? content_for(:meta_title) : t(:'testing.meta_title')
    end

    def meta_description
      content_for?(:meta_description) ? content_for(:meta_description) : t(:'testing.meta_description')
    end

    def meta_image
      meta_image = (content_for?(:meta_image) ? content_for(:meta_image) : image_path('og_image.png'))
      meta_image.starts_with?("http") ? meta_image : image_url(meta_image)
    end
  end
end