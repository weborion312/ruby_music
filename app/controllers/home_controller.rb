class HomeController < ApplicationController
  skip_before_filter :check_user_has_current_tc
  layout "home"

  def index
    redirect_to_terms_and_conditions
    respond_to do |format|
      format.html
      format.json
    end
  end

  private

  # If user has not accepted the Terms And Conditions,
  # redirect to T&C +edit+ page.
  def redirect_to_terms_and_conditions
    if current_user && !current_user.current_tc? && !params[:redirected]
      redirect_to root_url(:redirected => true)+"#!"+edit_acceptance_path
    end
  end
end
