# frozen_string_literal: true

class Dashboard::InfoComponent < ApplicationComponent
  attr_reader :title, :header, :image, :warning, :action_title, :action_link

  def initialize(title:, header:, image:, warning:, action_title:, action_link:)
    @title = title
    @header = header
    @image = image
    @warning = warning
    @action_title = action_title
    @action_link = action_link
  end
end
