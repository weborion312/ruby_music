class RenameIndexToPosition < ActiveRecord::Migration
  def up
    rename_column :plate_entries, :index, :position
    rename_column :broadcast_entries, :index, :position
  end

  def down
    rename_column :plate_entries, :position, :index
    rename_column :broadcast_entries, :position, :index
  end
end
