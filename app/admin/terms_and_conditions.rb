ActiveAdmin.register TermsAndConditions do
  index do
    id_column
    column :notes
    column :created_at
    column :updated_at
    column :active
    default_actions
  end

  form do |f|
    f.inputs 'Details' do
      f.input :notes
      f.input :content, :as => :text, :input_html => { :class => 'tiny_mce' }
      f.input :active
    end
    f.action :submit
  end
end
