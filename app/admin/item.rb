ActiveAdmin.register Item do
  permit_params :page_name, :text, :pdf_file

  form do |f|
    f.inputs 'Details' do
      f.input :page_name
      f.input :text
      if f.object.pdf_file.attached?
        pdf_file_name = f.object.pdf_file.filename.to_s
        pdf_file_url = url_for(f.object.pdf_file)
        f.input :pdf_file, as: :file, input_html: { style: 'display:none' },
                           hint: link_to(pdf_file_name, pdf_file_url)
      else
        f.input :pdf_file, as: :file
      end
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
      row :pdf_file do
        if resource.pdf_file.attached?
          pdf_file_name = resource.pdf_file.filename.to_s
          pdf_file_url = url_for(resource.pdf_file)
          link_to(pdf_file_name, pdf_file_url)
        else
          'No PDF file attached'
        end
      end
      row :created_at
      row :updated_at
    end
  end
end
