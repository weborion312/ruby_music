require 'spec_helper'


class ApplicationController < ActionController::Base
  class DummyError < StandardError; end
  rescue_from DummyError, :with => :dummy_error_handler

  private

  def dummy_error_handler
    redirect_to "/401.html"
  end
end


describe ApplicationController do
  controller do
    def index
      raise ApplicationController::DummyError
    end
  end

  let(:user) { User.make! }

  before do
    sign_in :user, user
  end

  it "should show access denied" do
    get :index
    response.should redirect_to("/401.html")
  end

  it "should set current user" do
    get :index
    controller.current_user.should be_a User
  end

  it "should check the current user object" do
    controller.should_receive(:current_user).at_least(:once).and_return(user)
    user.should_receive(:terms_and_conditions)
    xhr :get, :index
  end

  it "should allow a user to continue when they have accepted new TCs" do
    user.update_attribute(
                :terms_and_conditions,
                TermsAndConditions.make!(:active => true)
                )
    get :index
    response.should redirect_to("/401.html")
  end
end
