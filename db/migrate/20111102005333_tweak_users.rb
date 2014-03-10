class TweakUsers < ActiveRecord::Migration
  def up
    remove_column :users, :address
    add_column    :users, :location, :string
  end

  def down
    remove_column :users, :location
    add_column :users, :address, :text
  end
end