require 'spec_helper'

describe "Profile" do
  let(:user) { User.make! }

  it "redirects an un-logged user to sign in" do
    as_visitor(user)
    visit profile_path(user)
    page.should_not have_content "Your profile"
  end

  describe "Signed in user" do
    before do
      as_user(user)
      visit '/'
      page.should_not have_content "Your profile"
    end

    it "should show me a link to my profile on the home page" do
      page.find('header nav').should have_content "Logout"
      page.should have_content "My profile"
    end

    it "should take me to my profile when I click the Your profile link" do
      page.should have_content "Logout"
      click_link "My profile"
      page.find('#popup').should have_content user.email
    end
  end
end
