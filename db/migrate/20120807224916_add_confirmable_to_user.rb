class AddConfirmableToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at,       :datetime
    add_column :users, :confirmation_sent_at , :datetime

    add_index  :users, :confirmation_token, :unique => true

    User.update_all(:confirmed_at => Time.now)
  end

  def self.down
    remove_index  :users, :confirmation_token
    remove_column :users, :confirmation_sent_at, :confirmed_at , :confirmation_token
  end
end
