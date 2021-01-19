module MetaTagsHelper
  def meta_title
    content_for?(:meta_title) ? content_for(:meta_title) : t(:meta_title)
  end

  def meta_description
    content_for?(:meta_description) ? content_for(:meta_description) : t(:meta_description)
  end
end