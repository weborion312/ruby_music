require 'spec_helper'

describe Users::OmniauthController do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "Facebook" do
    before do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    end

    it "should find the user for Facebook" do
      User.should_receive(:find_for_oauth).with('facebook', request.env["omniauth.auth"]["uid"])
        .and_return(User.make!)
      get :facebook
    end

    describe "when there is an existing authentication record" do
      let(:user) { User.make! }
      before do
        User.stub(:find_for_oauth).and_return(user)
      end

      it "should sign in" do
        get :facebook
        controller.current_user.should == user
      end

      it "should redirect to the home page" do
        get :facebook
        response.should redirect_to root_url + "#!" + edit_profile_path(user)
      end

      it 'should update the avatar when signing in' do
        pending 'Investigate'
        user.update_attribute :avatar_url, nil
        get :facebook
        user.reload.avatar_url.should_not be_nil
      end
    end

    describe "when there is no authentication record" do
      before do
        User.stub(:find_for_oauth).and_return(nil)
      end

      describe "when the user is logged in" do
        let(:user) { User.make! }

        before do
          sign_in :user, user
          controller.stub(:current_user).and_return(user)
        end

        it "should create a new authentication record on the current user" do
          user.should_receive(:register_with_oauth).
            with(request.env["omniauth.auth"]["uid"], 'facebook')
          get :facebook
        end

        it "should redirect to the user's profile page" do
          get :facebook
          response.should redirect_to root_url + "#!" + profile_path(user)
        end
      end

      describe "when the user is not logged in" do
        let(:user) { User.make! }
        before do
          User.stub(:create_with_oauth).and_return(user)
        end

        it "should redirect to register" do
          get :facebook
          response.should redirect_to root_url + "#!/users/sign_up"
        end

        it "should store the oauth response in the session" do
          controller.should_receive(:set_session).with(request.env["omniauth.auth"])
          get :facebook
        end

        describe "It should sanitize the OmniAuth response to store in the session" do
          [:facebook, :twitter].each do |provider|
            describe "for #{provider.to_s.humanize}" do
              before do
                request.env["omniauth.auth"] = OmniAuth.config.mock_auth[provider]
                get provider
              end

              specify { controller.session[:oauth_response].should_not == nil }
              specify { controller.session[:oauth_response]["info"].should_not == nil }
              specify { controller.session[:oauth_response]["uid"].should_not == nil }
              specify { controller.session[:oauth_response]["provider"].should == provider.to_s }

              # Random trash to represent anything we have not white-listed
              specify { controller.session[:oauth_response]["random_trash"].should == nil }

              # Provider-specific fields
              if provider == 'facebook'
                specify { assigns(:omniauth_response)["extra"].should_not == nil }
                specify { assigns(:omniauth_response)["info"]["email"].should_not == nil }
              end
            end
          end
        end
      end
    end
  end

  describe "Twitter" do
    before do
      # Defined in spec/support/omniauth
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
    end

    it "should find the user for Twitter" do
      User.should_receive(:find_for_oauth).with('twitter', request.env["omniauth.auth"]['uid'])

      get :twitter
    end

    describe "when the user is new" do
      before do
        User.stub(:find_for_oauth).and_return(nil)
      end

      it "should force a registration if the user is not found" do
        get :twitter
        response.should redirect_to root_url + "#!/users/sign_up"
      end

      it "should save the oauth details to the session if the user needs to register first" do
        controller.should_receive(:set_session).with(request.env["omniauth.auth"])
        get :twitter
      end
    end

    describe "With an existing oauthed user" do
      let(:user) { User.make! }

      before do
        User.stub(:find_for_oauth).and_return(user)
      end

      it "should log me in when I oauth an existing user" do
        get :twitter
        controller.current_user.should == user
      end

      it "Should redirect me to home when I oauth and existing user" do
        get :twitter
        response.should redirect_to root_url + '#!' + edit_profile_path(user)
      end

      it 'should update the avatar when signing in' do
        pending 'investigate'
        user.update_attribute :avatar_url, nil
        get :twitter
        user.reload.avatar_url.should_not be_nil
      end
    end

    describe "with an existing unoauthed user" do
      let(:user) { User.make! }

      before do
        sign_in :user, user
      end

      it "should oauth an existing webjam user when that user is not already omniauthed" do
        controller.current_user.should_receive(:register_with_oauth)
          .with(request.env["omniauth.auth"]["uid"], 'twitter')
        get :twitter
      end

      it "should redirect to show_user when they are omniauthed" do
        get :twitter
        response.should redirect_to root_url + "#!" + profile_path(user)
      end
    end
  end
end
