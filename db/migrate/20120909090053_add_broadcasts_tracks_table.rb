class AddBroadcastsTracksTable < ActiveRecord::Migration
  def up
    create_table :broadcast_tracks do |t|
      t.references :broadcast, :null => false
      t.references :track, :null => false
      t.integer :position
    end
  end

  def down
    drop_table :broadcast_tracks
  end
end
