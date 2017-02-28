ActiveAdmin.register Tip do
  permit_params :title, :description, :content, :photo, :pack_id, :category_ids=>[]

  index do
    selectable_column
    id_column
    column :title
    column :description
    column "Photo", :photo_url
    column "Category", :category_name
    column "Pack", :pack_name
    actions
  end

  filter :title
  filter :category
  filter :pack

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Tip Details" do
      f.input :title
      f.input :description
      f.input :content, :as => :text, input_html: { class: "summernote" }
      f.input :photo, type: :file
      # f.input :category_ids, :as => :select, :collection => Category.all.map{|c| ["#{c.name}", c.id]}
      f.input :categories, :as => :check_boxes
      f.input :pack_id, :as => :select, :collection => Pack.all.map{|p| ["#{p.name}", p.id]}
    end
    f.actions
  end

end
