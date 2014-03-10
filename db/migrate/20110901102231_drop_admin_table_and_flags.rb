class DropAdminTableAndFlags < ActiveRecord::Migration
  def self.up
    drop_table :admins
    remove_column :users, :admin
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration, "Cannot recover deleted Admin table or admin column"
  end
end
