class CreateEventLogs < ActiveRecord::Migration
  def change
    create_table :event_logs do |t|
      t.references :user
      t.references :track
      t.string :event_type
      t.string :ip
      t.timestamps
    end
  end
end
