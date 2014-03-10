class Users::SessionsController < Devise::SessionsController

  def sign_in_successful
    render :json => {:sign_in => true}.as_json
  end

  def session_current_user
    if current_user
      render :json => current_user.as_json
    else
      render :nothing => true
    end
  end

  protected

  def after_sign_in_path_for(resource)
    sign_in_successful_url
  end
end
