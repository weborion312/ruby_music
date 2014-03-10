class AddAgeAcceptedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :age_accepted, :boolean
  end
end
