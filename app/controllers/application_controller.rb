class ApplicationController < ActionController::Base
  protect_from_forgery
  analytical

  layout lambda { |controller| controller.request.xhr? ? 'popup' : 'home' }

  before_filter :check_user_has_current_tc

  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  def show_welcome_page?
    #overriding refinery initialization wizard behavior, so
    #unpopulated test database will successfully run.
    false
  end

  def current_login_user
    return current_user
  end

  def require_validated
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to new_login_url # Prevents the current action from running
    end
  end

  def not_found
    respond_to do |format|
      format.html {render :file => "#{Rails.root}/public/404.html", :status => 404}
      format.json {head :not_found}
    end
  end

  # If a user is logged in, but needs to accept the new terms and conditions...
  def check_user_has_current_tc
    if request.xhr?
      if current_user && !current_user.current_tc?
        redirect_to edit_acceptance_url
      end
    end
  end

  def after_sign_in_path_for(resource)
   root_url + '#!' + edit_profile_path(resource)
  end

  def render_404
    render :text => 'not a valid iteration date', :status => 404
  end
end
