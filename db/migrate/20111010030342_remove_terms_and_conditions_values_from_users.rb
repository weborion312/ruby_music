class RemoveTermsAndConditionsValuesFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :terms_and_conditions
    remove_column :users, :terms_and_conditions_version
  end
  def down
    add_column :users, :terms_and_conditions, :boolean
    add_column :users, :terms_and_conditions_version, :integer
  end
end