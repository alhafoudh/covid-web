# frozen_string_literal: true

class Dashboard::AnnouncementComponent < ViewComponent::Base
  attr_reader :content

  def initialize(content:)
    @content = content
  end

  def render?
    content.present? && !content.empty?
  end
end
