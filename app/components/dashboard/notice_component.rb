# frozen_string_literal: true

class Dashboard::NoticeComponent < ViewComponent::Base
  attr_reader :type, :content, :classes, :class_name

  def initialize(type: :info, icon: nil, content:, class_name: '')
    @type = type
    @icon = icon
    @content = content
    @class_name = class_name
  end

  def render?
    content.present? && !content.empty?
  end

  def classes
    class_names(
      class_name,
      'text-red bg-red-light': type == :danger,
      'text-yellow bg-yellow-light': type == :warning,
      'text-green bg-green-light': type == :success,
      'text-blue bg-blue-light': type == :info,
    )
  end

  def icon
    if @icon.present?
      @icon
    else
      case type
      when :warning then
        :exclamation
      else
        :info
      end
    end
  end
end
