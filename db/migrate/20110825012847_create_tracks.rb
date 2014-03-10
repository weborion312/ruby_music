class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.string :media_file_name
      t.string :media_content_type
      t.integer :media_file_size
      t.string :media_access_token
      t.datetime :media_updated_at
      
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end
