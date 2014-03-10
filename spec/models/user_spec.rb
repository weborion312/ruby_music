require 'spec_helper'

describe User do
  let(:u) { User.make(:terms_and_conditions_accepted => nil ) }

  describe "validations" do
    it "uniqueness of username" do
      User.make!(:username => "foo")
      User.make(:username => "foo").valid?.should == false
    end

    it "case insensitive of username" do
      User.make!(:username => "foO")
      User.make(:username => "foo").valid?.should == false
      User.find_by_username("foO").id.should == User.find_by_username("foo").id
    end
  end

  describe "T&C" do
    it "should be assigned to new users" do
      tc = TermsAndConditions.make!
      u.terms_and_conditions = tc
      u.terms_and_conditions_id.should == tc.id
    end

    it "should relate user with current" do
      TermsAndConditions.make(:active => true)
      u.terms_and_conditions_accepted = 't'
      u.save
      u.terms_and_conditions.should == TermsAndConditions.current
    end

    it "should return whether it's current or not" do
      TermsAndConditions.make(:active => true)
      u.terms_and_conditions_accepted = 't'
      u.save
      u.current_tc?.should == true
    end

    it "should determine if user has accepted it" do
      u.valid?
      u.errors.messages[:terms_and_conditions_accepted].should include("You must agree to the terms and conditions")
    end
  end

  context "Activation and de-activation" do
    it "should default to active" do
      User.make!.active.should == true
    end

    it "should flag users as inactive when active is false" do
      User.make!(:active => false).active_for_authentication?.should == false
    end

    it "should flag users as active when active is true" do
      User.make!(:active => true).active_for_authentication?.should == true
    end
  end

  context "creating new user from session" do
    it "should return a new User" do
      User.new_with_session({}, {}).should be_a User
    end

    it "should generate a new User if no session is set" do
      User.should_receive(:new).with(:blah => :foo)
      User.new_with_session({:blah => :foo}, {})
    end

    it "should return an empty User when given an empty oauth response" do
      user = User.new_with_session({}, {:oauth_response => {}})
      user.attributes.should == User.new.attributes
    end
  end

  describe "Authentications" do
    let (:u) { User.make! }
    it "should return a list of authenticated providers" do
      u.authentications.create(:provider => "foo")
      u.authentications.create(:provider => "blah")
      u.authenticated_providers.should == ["blah", "foo"]
    end
  end

  describe 'display name' do
    context 'with a full name' do
      subject { User.new :full_name => 'Foobar' }
      its(:to_s) { should eq 'Foobar' }
      its(:display_name) { should eq 'Foobar' }
    end

    context 'with a username' do
      subject { User.new :username => 'foobarbaz' }
      its(:to_s) { should eq 'foobarbaz' }
      its(:display_name) { should eq 'foobarbaz' }
    end

    context 'with a full name and a username' do
      subject { User.new :full_name => 'Foobar', :username => 'foobarbaz' }
      its(:to_s) { should eq 'Foobar' }
      its(:display_name) { should eq 'Foobar' }
    end
  end

  describe '#active_avatar_url' do
    let(:user) { User.make! }

    context 'by default' do
      it 'should return a gravatar url' do
        user.active_avatar_url.should =~ /no_image_icon.png/
      end
    end
  end
end
