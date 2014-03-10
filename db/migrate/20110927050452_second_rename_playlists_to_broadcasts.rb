class SecondRenamePlaylistsToBroadcasts < ActiveRecord::Migration

  # We had playlists, which became broadcasts, then became plates
  #                   we had playlists (again), which became broadcasts
  #
  # Sorry this is so confusing! Refactoring sucks

  def change
    rename_table :playlists, :broadcasts
    rename_column :playlist_entries, :playlist_id, :broadcast_id
  end
end
