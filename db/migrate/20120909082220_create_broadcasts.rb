class CreateBroadcasts < ActiveRecord::Migration
  def up
    create_table :broadcasts do |t|
      t.integer :user_id
      t.string :image
      t.text :description
      t.string :title
      t.datetime :published_at
      t.timestamps
    end
  end

  def down
    drop_table :broadcasts
  end
end
