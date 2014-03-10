class AddDetailsToTracks < ActiveRecord::Migration
  def self.up
    change_table :tracks do |t|
      t.string :name

      t.boolean :private

      t.boolean :pulled
      t.datetime :pulled_at
      t.string :pulled_reason
    end
  end

  def self.down
    remove_column :tracks, :name
    remove_column :tracks, :private
    remove_column :tracks, :pulled
    remove_column :tracks, :pulled_at
    remove_column :tracks, :pulled_reason
  end
end
