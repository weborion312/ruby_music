require 'spec_helper'

describe Users::RegistrationsController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  it "should set t_and_c when new is called" do
    tc = TermsAndConditions.make!(:active => true, :content => "testy")
    get :new
    assigns(:t_and_c).should == tc
  end

  it "should receive set_t_and_c" do
    controller.should_receive(:set_t_and_c).and_return(TermsAndConditions.make!)
    get :new
  end

  it "should populate the flash when an oauth_response is in the session" do
    session[:tmp_provider] =  "facebook"
    get :new
    flash[:alert].should == "We have grabbed your details from Facebook. Please fill in this form to complete your registration"
  end

  it "should redirect to users edit profile path when registration succeeds" do
    post :create
    response.status.should == 200
  end

  it "should render a JSON object when signup_successful is accessed" do
    pending 'This should be re-implemented'
    get :sign_up_successful
    response.content_type.should == "application/json"
  end


  describe "After redirecting from an OAuth provider" do
    before do
      controller.session[:oauth_response] = {}
    end

    it "should set @oauth_signup to true" do
      get :new
      assigns(:oauth_signup).should == true
    end

    it "should pluck the oauth object out of the session and spawn a new user with it" do
      User.should_receive(:new_with_session).with({}, controller.session)
      get :new
    end

    it "should call new_with_session on User when new is called,  with params included" do
      User.should_receive(:new_with_session).with({"foo" => "blah"}, controller.session)
      get :new, :user => {:foo => :blah}
    end

    it "should call new_with_session on User on create" do
      User.should_receive(:new_with_session).with({}, controller.session)
        .and_return(User.new)
      post :create, :user => {}
    end
  end
end
