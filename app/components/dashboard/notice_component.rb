# frozen_string_literal: true

class Dashboard::NoticeComponent < ViewComponent::Base
  attr_reader :type, :content

  def initialize(type:, content:)
    @type = type
    @content = content
  end

  def render?
    content.present? && !content.empty?
  end

  def classes
    case type
    when :warning then 'text-red-600 bg-red-100'
    else
      'text-blue-600 bg-blue-100'
    end
  end
end
