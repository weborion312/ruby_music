class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :wall_percentage_track
      t.integer :wall_percentage_user
    end
  end
end
