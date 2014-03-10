require 'spec_helper'

module Opjam
  module TestHelpers
    include Devise::TestHelpers
    include Warden::Test::Helpers
    Warden.test_mode!

    # Will run the given code as the user passed in
    def as_user(user=nil, &block)
      current_user = user || User.make!
      if request.present?
        sign_in(current_user)
      else
        login_as(current_user, :scope => :user)
      end
      block.call if block.present?
      return self
    end

    def as_visitor(user=nil, &block)
      current_user = user || User.make!
      if request.present?
        sign_out(current_user)
      else
        logout(:user)
      end
      block.call if block.present?
      return self
    end

    def sign_in!(user)
      visit root_path
      page.find('header nav').click_link('Sign in')
      # page.find('footer nav.plates').click_link('Broadcasts')
      # page.find('header ul.options').click_link('Feedback')
      # page.find('header nav').click_link('Upload')
      within '#popup' do
        page.find('h2').should have_content('Operation Jam Sign In')
        fill_in 'user[email]', :with => user.email
        fill_in 'user[password]', :with => 'password'
        click_on 'Sign In'
      end
      page.should have_content 'Logout'
    end

    def sign_up!
      visit '/'
      click_on 'Sign up'
      within '.popup' do
        fill_in 'user[username]', :with => 'test'
        fill_in 'user[password]', :with => 'password'
        fill_in 'user[password_confirmation]', :with => 'password'
        fill_in 'user[email]', :with => 'test@test.com'
        check 'user[terms_and_conditions_accepted]'
        check 'user[age_accepted]'
        click_on 'Sign up'
      end
      page.should have_content 'Logout'
    end

    def sign_up_social!
      visit root_path
      click_on 'Sign up'
      within '.popup' do
        fill_in 'user[email]', :with => 'test@example.com'
        check 'user[terms_and_conditions_accepted]'
        check 'user[age_accepted]'
        click_button 'Sign up'
      end
      page.should have_content 'Logout'
    end

    # HACK! If we don't access the page object then the entire request gets ignored
    # http://github.com/thoughtbot/capybara-webkit/issues/205
    def page_load_hack
      page.should_not have_content 'ROGER'
    end

    def wait_for_ajax
      delay = 0.1
      while page.evaluate_script('jQuery.active') > 0
        sleep delay
        delay = [delay*2, 1.0].min
      end
    end

    def current_fragment
      URI.parse(current_url).fragment
    end

    def admin_sign_in!(user)
      visit new_admin_user_session_path
      fill_in 'admin_user[email]', :with => user.email
      fill_in 'admin_user[password]', :with => user.password
      click_button 'Login'
    end
  end
end
