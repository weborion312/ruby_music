class AddSlugToTrack < ActiveRecord::Migration
  def self.up
    change_table :tracks do |t|
      t.string :slug
    end
    add_index :tracks, :slug, unique: true
  end

  def self.down
    remove_column :tracks, :slug
  end
end
