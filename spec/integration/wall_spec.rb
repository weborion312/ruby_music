require 'spec_helper'

describe 'the wall', :js => true do
  describe 'plates' do
    let!(:users) { User.make! 5 }
    let!(:tracks) { Track.make! 5 }

    before { visit root_path }

    it 'should show all the of plates' do
      pending 'debug backbone'
      page.find('header a.logo').should have_content('Operation Jam')
      all('#stage li.poster').size.should eq 4 * 46
    end

    it 'should have user plates' do
      all('#stage li.poster.user').size.should > 0
    end

    it 'should have track plates' do
      all('#stage li.poster.track').size.should > 0
    end
  end
end
