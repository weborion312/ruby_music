class AdminUser < ActiveRecord::Base

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

##################
  # Refinery bits
  has_and_belongs_to_many :roles, :join_table => :roles_admin_users
  has_many :plugins, :class_name => "AdminUserPlugin", :order => "position ASC", :dependent => :destroy

  def plugins=(plugin_names)
    if persisted? # don't add plugins when the user_id is nil.
      AdminUserPlugin.delete_all(:admin_user_id => id)

      plugin_names.each_with_index do |plugin_name, index|
        plugins.create(:name => plugin_name, :position => index) if plugin_name.is_a?(String)
      end
    end
  end

  def authorized_plugins
    plugins.collect(&:name) | ::Refinery::Plugins.always_allowed.names
  end

  def can_delete?(user_to_delete = self)
    user_to_delete.persisted? &&
      !user_to_delete.has_role?(:superuser) &&
      ::Role[:refinery].users.any? &&
      id != user_to_delete.id
  end

  def can_edit?(user_to_edit = self)
    user_to_edit.persisted? && (
      user_to_edit == self ||
      self.has_role?(:superuser)
    )
  end

  def add_role(title)
    raise ArgumentException, "Role should be the title of the role not a role object." if title.is_a?(::Role)
    roles << ::Role[title] unless has_role?(title)
  end

  def has_role?(title)
    raise ArgumentException, "Role should be the title of the role not a role object." if title.is_a?(::Role)
    roles.any?{|r| r.title == title.to_s.camelize}
  end
##################

end
