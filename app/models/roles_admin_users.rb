# So we can use the same auth for refinery
class RolesAdminUsers < ActiveRecord::Base
  belongs_to :role
  belongs_to :admin_user
end
