class RenameBroadcastEntriesToPlateEntries < ActiveRecord::Migration
  def change
    rename_table :broadcast_entries, :plate_entries
  end
end
