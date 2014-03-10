class AddMediaArtworkToTrack < ActiveRecord::Migration
  def change
    add_column :tracks, :media, :string
    add_column :tracks, :artwork, :string
  end
end
