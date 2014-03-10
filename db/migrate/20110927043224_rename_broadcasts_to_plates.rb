class RenameBroadcastsToPlates < ActiveRecord::Migration
  def change
    rename_table :broadcasts, :plates

    rename_column :broadcast_entries, :broadcast_id, :plate_id
    rename_column :playlist_entries, :broadcast_id, :plate_id
  end
end
