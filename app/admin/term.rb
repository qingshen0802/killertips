ActiveAdmin.register Term do
  permit_params :terms

  index do
    selectable_column
    id_column
    column :terms
    actions
  end

  filter :terms

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Terms" do
      f.input :terms, :as => :text, input_html: { class: "summernote" }
    end
    f.actions
  end

end
