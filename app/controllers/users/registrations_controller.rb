class Users::RegistrationsController < Devise::RegistrationsController

  before_filter :set_t_and_c, :only => [:new, :create]

  def new
    if session[:tmp_provider]
      flash[:alert] = flash_message_for session[:tmp_provider]
    end

    @oauth_signup = session[:oauth_response].nil? ? false : true

    # Devise uses build_resource({}) to disable user hash
    resource = build_resource
    respond_with resource
  end

  def create
    build_resource
    resource.skip_confirmation!
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
end
    else
      flash[:notice] = "Please correct the following errors."
      clean_up_passwords resource
      respond_with resource
    end
  end

  private

  def after_sign_in_path_for resource
    flash[:notice] = "Please check your email in order to verify your account."
    root_url + '#!' + edit_profile_path(resource)
  end

  def set_t_and_c
    @t_and_c = TermsAndConditions.current
  end

  def flash_message_for provider
    "We have grabbed your details from #{provider.capitalize}. " +
    "Please fill in this form to complete your registration"
  end
end
