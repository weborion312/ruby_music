class AddProfileFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username,   :string
    add_column :users, :full_name,  :string
    add_column :users, :address,    :text
    add_column :users, :interests,  :text
    add_column :users, :birth_date, :date
  end
end
