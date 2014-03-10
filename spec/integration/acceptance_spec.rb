require 'spec_helper'
describe "Acceptance", :js => true do
  describe "Updated terms and conditions" do
    let(:user) { User.make! }
    before do
      sign_in! user
      page.should have_content "Logout"
    end

    it "should redirect me to home with the T&C in a popup" do
      TermsAndConditions.make!(:content => "cats", :active => true)
      visit "/"
      current_path.should == "/"
      page.should have_content "cats"
    end

    it "should render the T&C form if I request anything via XHR" do
      get "/" 
      page.should have_content "My profile"
      TermsAndConditions.make!(:content => "roger", :active => true)
      click_link "My profile"
      page.should have_content "roger"
    end
  end
end

# if "/anything"
#   redirect_to home, with #show/tc_stuff
# if "#show/ajax_request"
#   render the acceptance page instead
# if "/"
#   add #show/acceptance
#   
