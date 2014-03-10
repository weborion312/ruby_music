class AcceptanceController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_user
  before_filter :set_terms_and_conditions, :only => [:edit, :update]

  skip_before_filter :check_user_has_current_tc, :only => [:edit, :update]

  layout false

  def edit
  end

  # Manually check T&C here
  def update
    if @user.update_attribute(:terms_and_conditions, @t_and_c)
      render :json => {:tc_accepted => true}.to_json
    else
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
  end

  def set_terms_and_conditions
    @t_and_c = TermsAndConditions.current
  end
end
