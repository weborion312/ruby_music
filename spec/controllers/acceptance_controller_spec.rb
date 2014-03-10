require 'spec_helper'

describe AcceptanceController do
  let(:user) { User.make! }

  before do
    sign_in :user, user
  end

  it "should render edit" do
    get :edit
    response.should render_template "acceptance/edit"
  end

  it "should find the user" do
    get :edit
    assigns(:user).should == user
  end

  it "should let me update" do
    User.any_instance.should_receive(:update_attribute)
    put :update
  end

  it "should render a blob of json when successful" do
    put :update
    response.should be_success
  end
end
