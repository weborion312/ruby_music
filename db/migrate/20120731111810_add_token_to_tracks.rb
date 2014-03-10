class AddTokenToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :token, :string

    Track.reset_column_information

    Track.all.each do |t|
      t.update_attributes!(:token => ::SecureRandom.urlsafe_base64(8)) unless t.token
    end
  end

  def self.down
    remove_column :tracks, :token
  end
end
