class AddMp3AndOgaToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :mp3, :string
    add_column :tracks, :oga, :string
  end

  def self.down
    remove_column :tracks, :mp3, :oga
  end
end
