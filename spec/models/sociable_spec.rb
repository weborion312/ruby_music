require 'spec_helper'

describe Sociable do
  let(:u) { User.make! }
  context "new user " do
    let(:twitter_session) { {"provider" => "twitter", "uid" => "cats"} }
    let(:facebook_session) { {"provider" => "facebook", "uid" => "cats"} }

    it "should generate a Facebook user if the session has a Facebook oauth response" do
      User.should_receive(:new_with_facebook_session).with({}, facebook_session).and_return u
      User.new_with_session({}, {:oauth_response => facebook_session})
    end

    it "should generate a Twitter user if the session has a Twitter oauth response" do
      User.should_receive(:new_with_twitter_session).with({}, twitter_session).and_return u
      User.new_with_session({}, {:oauth_response => twitter_session})
    end

    describe "handling of authentications" do
      ["twitter", "facebook"].each do |provider|
        describe "Authentication for #{provider}" do
          let(:session) { {"provider" => provider, "uid" => "cats"} }
          let(:user) do
            User.new_with_session({}, {:oauth_response => session})
          end

          specify { user.authentications.length.should == 1 }
          specify { user.authentications.first.uid.should == session["uid"] }
          specify { user.authentications.first.provider.should == provider }
        end
      end
    end

    describe "new with Twitter session" do
      let(:session) do
        {
          :oauth_response => OmniAuth.config.add_mock(:twitter, TWITTER_OAUTH_RESPONSE)
        }
      end

      it "should return a user with the Twitter-provided data" do
        user = User.new_with_session({}, session)
        user.username.should  == TWITTER_OAUTH_RESPONSE["info"]["nickname"]
        user.full_name.should == TWITTER_OAUTH_RESPONSE["info"]["name"]
        user.location.should  == TWITTER_OAUTH_RESPONSE["info"]["location"]
        user.interests.should == TWITTER_OAUTH_RESPONSE["info"]["description"]
        # TODO: CarrierWave conflict
        # user.avatar_url.should == TWITTER_OAUTH_RESPONSE["info"]["image"]
      end

      it "should simply render an empty new User if the oauth response is malformed" do
        session[:oauth_response].delete "info"
        user = User.new_with_session({}, session)
        user.should_not be_persisted
      end

      it "should merge params with oauth details" do
        session[:oauth_response]["info"].delete "location"
        User.new_with_session({:location => "blah"}, session).location.should == "blah"
      end

      it "should override oauth details with params" do
        User.new_with_session({:location => "blah"}, session).location.should == "blah"
      end

    end

    describe "new with Facebook session" do
      let(:session) do
        {
          :oauth_response => OmniAuth.config.add_mock(:facebook, FACEBOOK_OAUTH_RESPONSE)
        }
      end

      it "should return a user with the Facebook-provided data" do
        user = User.new_with_session({}, session)
        user.username.should == FACEBOOK_OAUTH_RESPONSE["info"]["nickname"]
        user.full_name.should == FACEBOOK_OAUTH_RESPONSE["info"]["name"]
        user.email.should == FACEBOOK_OAUTH_RESPONSE["info"]["email"]
        # TODO: CarrierWave conflict
        # user.avatar_url.should == FACEBOOK_OAUTH_RESPONSE["info"]["image"]
        user.location.should == FACEBOOK_OAUTH_RESPONSE["extra"]["user_hash"]["location"]["name"]
        user.interests.should == FACEBOOK_OAUTH_RESPONSE["extra"]["user_hash"]["bio"]
      end

      it "should set a field to nil when it or its parent is nil" do
        session[:oauth_response].delete "extra"
        user = User.new_with_session({}, session)
        user.location.should == nil 
      end

      it "should simply render an empty new User if the oauth response is malformed" do
        session[:oauth_response].delete "info"
        user = User.new_with_session({}, session)
        user.should be_a User
      end

      it "should merge params with oauth details" do
        session[:oauth_response]["info"].delete "name"
        User.new_with_session({:full_name => "blah"}, session).full_name.should == "blah"
      end

      it "should override oauth details with params" do
        User.new_with_session({:location => "blah"}, session).location.should == "blah"
      end
    end
  end

  describe "Twitter oauth" do
    let(:user) { Array.new(10, User.make!).sample }
    let(:good_user) { User.make! }
    let(:bad_user)  { User.make! }

    [:twitter, :facebook].each do |provider|

      it "should only return a #{provider.to_s}-authed user with a given UID" do
        registration = Authentication.make!(:user => user, :provider => provider.to_s)
        User.find_for_oauth(provider, registration.uid).should == user
      end

      it "should not return read-only results" do
        registration = Authentication.make!(:user => user, :provider => provider.to_s)
        User.find_for_oauth(provider, registration.uid).readonly?.should == false
      end

      it "should let me register with omniauth" do
        user.register_with_oauth("123", provider)
        user.authentications.first.uid.should == "123"
      end

      it "should find a user after I register with omniauth" do
        user.register_with_oauth("123", provider)
        User.find_for_oauth(provider, "123").should == user
      end

      it "checks to see that the correct provider is being oauthed against" do
        good_registration = Authentication.make!(:user => good_user, :provider => provider.to_s)
        bad_registration  = Authentication.make!(:user => bad_user,  :provider => "bad provider")

        User.find_for_oauth(provider, good_registration.uid).should == good_user
        User.find_for_oauth(provider, bad_registration.uid).should == nil
      end
    end
  end

  describe "Authentications" do
    it "should return a list of authenticated providers" do
      u.authentications.create(:provider => "foo")
      u.authentications.create(:provider => "blah")
      u.authenticated_providers.should == ["blah", "foo"]
    end
  end
end
