class AddPositionToTracks < ActiveRecord::Migration
  def up
    remove_column :broadcast_tracks, :position
    add_column :tracks, :position, :integer
  end

  def down
    add_column :broadcast_tracks, :position
    remove_column :tracks, :position
  end
end
