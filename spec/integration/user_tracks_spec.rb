require 'spec_helper'

describe 'User tracks', :js => true do
  let(:user) { User.make! }
  let!(:track) { Track.make! :name => 'First track', :user => user }
  let!(:other_track) { Track.make! :name => 'Other track' }

  before do
    as_user(user)
    visit root_path + '#!/user/tracks'
  end

  it 'should display the correct#popup' do
    current_path.should == root_path
    current_fragment.should == '!' + user_tracks_path
    page.find('#popup div.title.green.text-left h2').should have_content 'Manage Your Tracks'
  end

  it 'should show a list of tracks' do
    within '#popup ul.products-list div.products-box div.text-holder' do
      page.should have_content '2 is the track duration'
    end
  end

  it 'should not show tracks owned by other users' do
    within '#popup ul.products-list' do
      page.should_not have_content 'Other track'
    end
  end

  context 'uploading track' do
    before do
      # as_user(user)
      # visit root_path + '#!/user/tracks'
      within '#popup #content' do
        page.should have_content 'Upload'
        click_link 'Upload'
      end
      current_fragment.should == '!' + new_user_track_path
      current_path.should == root_path
    end

    it 'should show validation errors' do
      within('#popup .popup.small-popup') do
        page.find('div.title.green.text-left').should have_content 'Track Upload'
        page.find('input.btn.btn-update').click
        # TODO: vaidate for an error msg.
        page.should have_content 'Track Upload'
      end
    end

    it 'should accept a file and redirect to the edit page' do
      within('#popup .popup.small-popup') do
        page.find('div.title.green.text-left').should have_content 'Track Upload'
        attach_file 'track[media]', Rails.root + 'spec/support/empty.mp3'
        # save_and_open_page
        page.find('input.btn.btn-update').click
        page.should_not have_content 'Track Upload'
      end

      current_path.should == root_path

      within '#popup .title.pink' do
        page.should have_content 'empty'
      end
    end
  end

  context 'editing track' do
    before do
      # as_user(user)
      # visit root_path + '#!/user/tracks'
      within('#popup .manage-tracks') do
        all('ul.products-list li')[0].click_link('Edit') # First track
      end
      current_path.should == root_path
      current_fragment.should == '!' + edit_user_track_path(track.slug)
    end

    it 'should render correct layout' do
      page.should have_content 'My profile'
      within '#popup #content' do
        page.should_not have_content 'My profile'
      end
    end

    it 'should show validation errors' do
      pending 'TODO: msgs'
      page.should_not have_content "can't be blank"
      fill_in 'track[name]', :with => ''
      click_button 'Update Track'
      page.should have_content "can't be blank"
    end

    it 'should show track#edit page after updating' do
      page.find('#popup .title').should have_content 'empty'
      fill_in 'track[name]', :with => 'Updated track name'
      page.find('input.btn.btn-update').click

      within '#popup .title' do
        page.should have_content 'Updated track name'
      end
    end

    context 'should accept artwork' do
      before do
        attach_file 'track[artwork]', Rails.root + 'spec/support/cover_001.jpg'
        page.find('input.btn.btn-update').click
      end

      it 'should display the image' do
        page.find('#popup .visual img')[:src].should =~ /cover_001.jpg/
      end
    end
  end
end
