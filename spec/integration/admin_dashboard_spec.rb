require 'spec_helper'

describe 'Admin dashboard', :request => true do
  before do
    admin_sign_in! AdminUser.make!
  end

  it 'should link to show pages' do
    user = User.make!
    visit admin_dashboard_path
    current_path.should == admin_dashboard_path
    find("#user_#{user.id} .resource_id_link").click
    current_path.should == admin_user_path(user)
  end
end
