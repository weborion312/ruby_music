class RenamePlaylistsToBroadcasts < ActiveRecord::Migration
  def change
    rename_table :playlists, :broadcasts
    rename_table :playlist_entries, :broadcast_entries
    rename_column :broadcast_entries, :playlist_id, :broadcast_id
  end
end
