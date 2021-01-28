# frozen_string_literal: true

class Dashboard::InfoComponent < ViewComponent::Base
  def initialize(content:)
    @content = content
  end
end
