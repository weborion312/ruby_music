require 'spec_helper'

describe 'User sign up', :js => true do
  # let(:user) {User.make!}
  let!(:users) { User.make! 5 }
  let!(:tracks) { Track.make! 5 }


  describe 'direct' do
    it 'should prompt for email address and password' do
      # as_visitor(user) do
        visit "/"
        # visit sign_up_path
        page.find('header nav').click_link('Sign up')
        page.should have_content( 'Operation Jam Sign Up')
        page.should have_content( 'Sign Up')
        page.should have_field('user[email]')
        page.should have_field('user[password]')
        find_field('user[email]').value.should be_empty
        find_field('user[password]').value.should be_empty
      # end
      wait_for_ajax
    end
  end

  describe 'via Twitter' do
    before do
      User.count.should eq 0
      visit root_path
      page.find('header nav').click_link('Sign up')
      click_link 'twitter'
      page.should have_content 'We have grabbed your details from Twitter'
    end

    it 'should prepopulate username with Twitter nickname' do
      find_field('user[username]').value.should eq TWITTER_OAUTH_RESPONSE['info']['nickname']
    end

    it 'should prompt for an email address but not a password' do
      page.should have_field('user[email]')
      page.should have_no_field('user[password]')
      find_field('user[email]').value.should be_empty
    end

    it 'should create account with just an email address' do
      fill_in 'user[email]', :with => 'test+twitter@example.com'
      check 'I accept these terms & conditions'
      check 'I am at least 13 years old'
      page.should_not have_content 'Logout'
      click_button 'Sign up'
      page.should have_content 'Logout'
    end
  end

  describe 'via MySpace' do
    before do
      User.count.should eq 0
      visit root_path
      click_on 'Sign up'
      click_link 'myspace'
      page.should have_content 'We have grabbed your details from MySpace'
    end

    it 'should prepopulate username with MySpace data' do
      find_field('user[username]').value.should eq MYSPACE_OAUTH_RESPONSE['info']['nickname']
    end

    it 'should prompt for an email address but not a password' do
      page.should have_field('user[email]')
      page.should have_no_field('user[password]')
    end

    it 'should log me in if I accept the T&C and sign up' do
      sign_up_social!
      current_path.should == root_path
      page.should have_content 'Logout'
    end

    context 'should let me sign up with MySpace' do
      before do
        sign_up_social!
        visit destroy_admin_user_session_path
        visit root_path
        page.should have_content 'Sign in'
      end

      it 'should let me sign up, then log out and log in via MySpace' do
        click_on 'Sign in'
        click_link 'myspace'
        page.should have_content 'Logout'
      end

      it 'should not let me login via Twitter' do
        click_on 'Sign in'
        click_link 'twitter'
        page.should_not have_content 'Logout'
      end
    end
  end

  describe 'via Facebook' do
    before do
      User.count.should eq 0
      visit root_path
      click_on 'Sign up'
      click_link 'facebook'
      page.should have_content 'We have grabbed your details from Facebook'
    end

    it 'should prepopulate username and email with Facebook data' do
      find_field('user[username]').value.should eq FACEBOOK_OAUTH_RESPONSE['info']['nickname']
      find_field('user[email]').value.should eq FACEBOOK_OAUTH_RESPONSE['info']['email']
    end

    it 'should prompt for an email address but not a password' do
      page.should have_field('user[email]')
      page.should have_no_field('user[password]')
    end

    it 'should log me in if I accept the T&C and sign up' do
      sign_up_social!
      current_path.should == root_path
      page.should have_content 'Logout'
    end

    context 'should let me sign up with Facebook' do
      before do
        sign_up_social!
        visit destroy_admin_user_session_path
        visit root_path
        page.should have_content 'Sign in'
      end

      it 'should let me sign up, then log out and log in via Facebook' do
        click_on 'Sign in'
        click_link 'facebook'
        page.should have_content 'Logout'
      end

      it 'should not let me login via Twitter' do
        click_on 'Sign in'
        click_link 'twitter'
        page.should_not have_content 'Logout'
      end
    end
  end

  describe 'linking social to an existing direct account' do
    before do
      @user = User.make!
      sign_in! @user
      click_link 'My profile'
    end

    it 'should have a Link to Facebook option' do
      page.should have_content 'Link account with Facebook'
    end

    describe 'When I link with Facebook' do
      before do
        click_link 'Link account with Facebook'
      end

      it 'should redirect me my profile' do
        page.should have_content 'Your Profile'
      end

      it 'should not allow me to link to Facebook again' do
        page.should_not have_content 'Link account with Facebook'
      end

      it 'should still show option to link to Twitter' do
        page.should have_content 'Link account with Twitter'
      end

      it 'should still show option to link to MySpace' do
        page.should have_content 'Link account with Myspace'
      end
      it 'should show that I have linked to Facebook' do
        page.should have_content 'You have authenticated with Facebook'
      end
    end
  end
end
