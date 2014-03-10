require 'active_admin/resource_controller'
ActiveAdmin.register User do
  index do
    id_column
    column :email
    column :username
    column :created_at
    column :updated_at
    column :sign_in_count
    column :current_sign_in_ip
    column :current_sign_in_at
    column :last_sign_in_ip
    column :last_sign_in_at
    column :active
    column '', :sortable => false do |user|
      link_to 'Pull', pull_user_tracks_admin_user_tracks_url(user), :method => :put
    end
    column '', :sortable => false do |user|
      link_to 'Tracks', admin_user_tracks_url(user)
    end

    default_actions
  end

  show do
    h3 do
      link_to 'View Tracks', admin_user_tracks_url(user)
    end
    h3 do
      link_to 'Pull Tracks', pull_user_tracks_admin_user_tracks_url(user), :method => :put
    end

    attributes_table :email, :full_name, :created_at, :updated_at,
                     :sign_in_count, :current_sign_in_ip, :current_sign_in_at,
                     :last_sign_in_ip, :last_sign_in_at, :active
  end

  form do |f|
    f.inputs 'Details' do
      f.input :email
      f.input :username
      f.input :active
      f.input :full_name
      f.input :location
      f.input :interests
    end
    f.action :submit
  end
end
