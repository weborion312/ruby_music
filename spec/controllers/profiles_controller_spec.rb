require 'spec_helper'

describe ProfilesController do
  let(:user) { User.make! }

  before do
    sign_in :user, user
  end

  it "set current user when logged in" do
    get :show, :id => user.slug
    controller.current_user.should be_a User
  end

  it "render edit profile" do
    get :edit, :id => user.slug
    response.should be_success
  end

  it "let me update" do
    User.any_instance.should_receive(:update_attributes)
        .with("foo" => "bar").and_return(true)
    put :update, :user => {:foo => :bar}, :id => user.slug
    response.should redirect_to "#!/profiles/" + user.slug
  end

  it "render edit when updates fail" do
    User.any_instance.stub(:valid?).and_return false
    put :update, :user => {}, :id => user.slug
    response.should redirect_to '#!' + edit_profile_path(user)
  end

  describe "xhr requests" do
    render_views
    it "does not render layout for xhr requests by default" do
      xhr :get, :edit, :id => user.slug
      response.body.should_not include("<html>")
    end
  end
end
