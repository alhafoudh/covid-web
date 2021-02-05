# frozen_string_literal: true

class Dashboard::CapacityBadgeComponent < ViewComponent::Base
  attr_reader :count, :size, :show_label

  def initialize(count:, size: :normal, show_label: false)
    @count = count
    @size = size
    @show_label = show_label
  end

  def classes
    class_names(
      color_classes,
      'text-xs px-2 py-0.5': size == :small,
      'text-sm px-2 py-1': size != :small,
    )
  end

  def color_classes
      class_names(
        'bg-green-light text-green': count >= 200,
        'bg-yellow-100 text-yellow-600': count >= 100 && count < 200,
        'bg-red-light text-red': count < 100,
      )
  end

  def value
    if show_label
      t(:free_capacity, count: count, formatted_count: formatted_count)
    else
      formatted_count
    end
  end

  def formatted_count
    number_with_delimiter(count)
  end
end
