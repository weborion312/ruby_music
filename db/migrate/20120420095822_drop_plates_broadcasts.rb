class DropPlatesBroadcasts < ActiveRecord::Migration
  def change
    drop_table :broadcasts
    drop_table :broadcast_entries
    drop_table :plate_entries
    drop_table :plates
  end
end
