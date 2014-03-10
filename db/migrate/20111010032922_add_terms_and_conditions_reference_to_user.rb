class AddTermsAndConditionsReferenceToUser < ActiveRecord::Migration
  def change
    add_column :users, :terms_and_conditions_id, :integer
  end
end