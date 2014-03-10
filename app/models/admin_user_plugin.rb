# So we can use the same auth for refinery
class AdminUserPlugin <ActiveRecord::Base
  belongs_to :admin_user
  attr_accessible :admin_user_id, :name, :position
end
