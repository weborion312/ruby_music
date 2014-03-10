class CreateRolesUsers < ActiveRecord::Migration
  def change
    create_table :roles_admin_users do |t|
      t.integer :admin_user_id
      t.integer :role_id
      t.timestamps
    end
    add_index :roles_admin_users, [:role_id, :admin_user_id]
    add_index :roles_admin_users, [:admin_user_id, :role_id]

    create_table :roles do |t|
      t.string :title
      t.timestamps
    end

    create_table :admin_user_plugins do |t|
      t.integer :admin_user_id
      t.string  :name
      t.integer :position
      t.timestamps
    end
    add_index :admin_user_plugins, :name
    add_index :admin_user_plugins, [:admin_user_id, :name], :unique => true


    Role.reset_column_information
    Role.create :title => 'Superuser'
    Role.create :title => 'Refinery'
  end

  def self.down
    drop_table :roles_admin_users
    drop_table :roles
    drop_table :admin_user_plugins
  end
end
