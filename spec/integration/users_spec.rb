require 'spec_helper'

describe "Registrations", :js => true, :type => :request do
  let(:user) {User.make!}

  before do
    @tc = TermsAndConditions.make!(:active => true, :content => "Somewhat fuzzy")
    as_visitor(user)
    visit root_path
    page.find('header nav').should have_content "Sign up"
    page.find('header nav').click_link "Sign up"
  end

  it "should require me to accept the terms and conditions" do
    pending '/login /signup bug'
    within('#popup') do
      fill_in "user[email]", :with => "testabc@gmail.com"
      fill_in "user[password]", :with => "password"
      fill_in "user[password_confirmation]", :with => "password"
      page.find('#popup div.popup.small-popup .btns input').click
      page.should have_content "You must agree to the terms and conditions"
    end
  end

  it "should let me register", :js => true do
    as_user(user)
    current_path.should == "/"
    page.find('header nav').click_link "Logout"
  end

end

describe "User logins", :js => true, :type => :request do
  it "should let me view the login page" do
    visits sing_in_path
    page.find('header nav').should have_content "Sign in"
  end

  it "should not let an inactive user login" do
    user = User.make! :active => false
    visit root_path
    click_link 'Sign in'
    fill_in 'user[email]', :with => user.email
    fill_in 'user[password]', :with => 'password'
    click_button 'Sign in'
    page.should have_content 'Sign in'
    page.should_not have_content 'Logout'
    page.should have_content 'Your account was not activated yet'
  end

  describe "Having attempted signed in" do
    let(:user) {User.make!(:terms_and_conditions => TermsAndConditions.current)}

    before :each do
      as_user(user)
    end

    it "displays successful signin content" do
      current_path.should == "/"
      page.find('header nav').should have_content "Logout"
    end

    describe "having then signed out" do
      before do
        visit "Logout"
      end

      it 'displays Login link' do
        current_path.should == "/"
        page.find('header nav').should have_content "Log in"
      end
    end
  end
end
