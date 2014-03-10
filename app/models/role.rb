# So we can use the same auth for refinery
class Role < ActiveRecord::Base

  has_and_belongs_to_many :admin_users, :join_table => ::RolesAdminUsers.table_name

  before_validation :camelize_title
  validates :title, :uniqueness => true

  attr_accessible :title

  def camelize_title(role_title = self.title)
    self.title = role_title.to_s.camelize
  end

  def self.[](title)
    find_or_create_by_title(title.to_s.camelize)
  end
end
