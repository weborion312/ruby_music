class CreateOldPlaylists < ActiveRecord::Migration
  def self.up
    create_table :playlists do |t|
      t.string :name

      t.string :artwork_file_name
      t.string :artwork_content_type
      t.integer :artwork_file_size
      t.datetime :artwork_updated_at

      t.references :user

      t.timestamps
    end

    create_table :playlist_entries do |t|
      t.references :playlist
      t.references :track

      t.integer :index

      t.timestamps
    end
  end

  def self.down
    drop_table :playlists
    drop_table :playlist_entries
  end
end
