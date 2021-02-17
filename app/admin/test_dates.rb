ActiveAdmin.register TestDate do
  menu priority: 4

  config.sort_order = 'date_asc'

  actions :index

  filter :date

  index do
    id_column
    column :date
  end
end
