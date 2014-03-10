class Users::PasswordsController < Devise::PasswordsController

  protected

  def after_sign_in_path_for(resource_or_scope)
    sign_in_successful_url
  end
end
