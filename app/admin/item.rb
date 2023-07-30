ActiveAdmin.register Item do
  permit_params :page_name, :text

  form do |f|
    f.inputs 'Details' do
      f.input :page_name
      f.input :text
    end

    actions
  end

  index do
    selectable_column
    id_column
    column :page_name
    column :text
    column :created_at
    column :updated_at

    actions
  end

  filter :id
  filter :page_name
  filter :text
  filter :embedding
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :id
      row :page_name
      row :text
      row :has_embedding do |item|
        item.embedding.present?
      end
      row :created_at
      row :updated_at
    end
  end
end
