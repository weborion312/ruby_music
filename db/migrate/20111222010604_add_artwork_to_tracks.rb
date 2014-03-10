class AddArtworkToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :artwork_file_name, :string
    add_column :tracks, :artwork_content_type, :string
    add_column :tracks, :artwork_file_size, :integer
    add_column :tracks, :artwork_updated_at, :datetime
  end
end
