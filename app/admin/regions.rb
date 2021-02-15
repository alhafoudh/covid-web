ActiveAdmin.register Region do
  menu priority: 2

  config.sort_order = 'name_asc'

  actions :index, :show

  index do
    id_column
    column :name
    column :external_id
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :external_id
end
