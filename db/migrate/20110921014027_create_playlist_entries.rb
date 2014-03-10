class CreatePlaylistEntries < ActiveRecord::Migration
  def change
    create_table :playlist_entries do |t|
      t.references  :playlist
      t.references  :broadcast
      t.integer     :index
      t.timestamps
    end
  end
end
