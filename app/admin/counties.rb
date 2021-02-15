ActiveAdmin.register County do
  menu priority: 3

  config.sort_order = 'name_asc'

  actions :index, :show

  index do
    id_column
    column :region
    column :name
    column :external_id
    actions
  end

  filter :region
  filter :name
  filter :external_id

  controller do
    def scoped_collection
      end_of_association_chain.includes(:region)
    end
  end
end
