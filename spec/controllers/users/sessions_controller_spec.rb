require 'spec_helper'

describe Users::SessionsController do
  let(:user) { User.make!(:password => "password") }
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  it "should redirect to our custom 'sign in  successful' path when log in succeeds" do
    post :create, :user => {:email => user.email, :password => "password"}
    response.should redirect_to sign_in_successful_url
  end

  it "should render a JSON object when signup_successful is accessed" do
    get :sign_in_successful
    response.content_type.should == "application/json"
  end


  it "should let me log out" do
    sign_in :user, user
    delete :destroy
    response.should redirect_to root_url
  end
end
