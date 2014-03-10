class RenamePlaylistEntriesToBroadcastEntries < ActiveRecord::Migration
  
  def change
    rename_table :playlist_entries, :broadcast_entries
  end
end
