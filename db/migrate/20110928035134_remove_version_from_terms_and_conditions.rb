class RemoveVersionFromTermsAndConditions < ActiveRecord::Migration
  def up
    remove_column :terms_and_conditions, :version
  end

  def down
    add_column :terms_and_conditions, :version, :integer
  end
end
