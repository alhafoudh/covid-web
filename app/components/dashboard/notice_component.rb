# frozen_string_literal: true

class Dashboard::NoticeComponent < ApplicationComponent
  attr_reader :type, :message, :classes, :class_name

  with_content_areas :actions

  def initialize(type: :info, icon: nil, message:, class_name: '')
    @type = type
    @icon = icon
    @message = message
    @class_name = class_name
  end

  def render?
    message.present? && !message.empty?
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
