ActiveAdmin.register Override do
  permit_params :type, :enabled, :name, :matches, :replacements

  menu priority: 8

  config.sort_order = 'created_at_desc'

  index do
    id_column
    column :type
    column :enabled
    column :name
    column :matches do |record|
      content_tag :pre, JSON.pretty_generate(record.matches)
    end
    column :replacements do |record|
      content_tag :pre, JSON.pretty_generate(record.replacements)
    end
    actions
  end

  filter :type
  filter :enabled
  filter :name
  filter :external_id

  form do |f|
    f.inputs do
      f.input :id, input_html: { readonly: true, disabled: true }
      f.input :type, as: :select, collection: %w{PlaceOverride}
      f.input :enabled
      f.input :name
      f.input :matches, input_html: { value: JSON.pretty_generate(f.object.matches) }
      f.input :replacements, input_html: { value: JSON.pretty_generate(f.object.replacements) }
    end
    f.actions
  end

  before_save do |record|
    record.matches = JSON.parse(permitted_params.dig(:override, :matches))
    record.replacements = JSON.parse(permitted_params.dig(:override, :replacements))
  end
end
