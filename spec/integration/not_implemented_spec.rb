require 'spec_helper'
describe 'when clicking on a not implemented feature', :js => true do
  let(:user) { User.make! }

  it 'displays a "Not implemented" titler' do
    visit root_path
    page.find('footer nav.plates').click_link('Broadcasts')
    within '#popup' do
      page.find('h2').should have_content('Not Implemented')
    end
  end
end
