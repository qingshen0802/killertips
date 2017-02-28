ActiveAdmin.register Pack do
  permit_params :name, :description, :price, :product_id

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :price
    column :product_id
    actions
  end

  filter :name

  form do |f|
    f.inputs "Pack Details" do
      f.input :name
      f.input :description
      f.input :price
      f.input :product_id
    end
    f.actions
  end

end
