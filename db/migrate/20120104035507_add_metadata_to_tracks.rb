class AddMetadataToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :artist,      :string
    add_column :tracks, :tags,        :string
    add_column :tracks, :description, :text
    add_column :tracks, :duration,    :integer
  end
end
