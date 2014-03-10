Opjam::Application.routes.draw do

  resources :broadcasts

  mount Jasminerice::Engine, :at => "/jasmine" if Rails.env =~ /development|test/

  root :to => 'home#index'

  match 'home/plate_rows' => "home#index", :format => true
  match 'not_implemented' => "profiles#not_implemented"

  ActiveAdmin.routes(self)

  namespace :api, :defaults => {:format => 'json'} do
    namespace :v1 do
      resources :tracks
      resources :users
      resources :broadcasts
    end
  end

  devise_for :admin_users, ActiveAdmin::Devise.config

  authenticate do
    mount Resque::Server.new, :at => "/resque"
  end

  devise_for :users,
    :class_name => User,
    :controllers => {
      :omniauth_callbacks => 'users/omniauth',
      :registrations => 'users/registrations',
      :sessions => 'users/sessions',
      :passwords => 'users/passwords',
      :confirmations => 'users/confirmations',
    },
    :path => '',
    :path_names => {
      :sign_in => 'login',
      :sign_out => 'logout',
    }

  devise_scope :user do
    match '/users/auth/:provider' => 'users/omniauth#passthru'
    match 'users/sign_in_successful',
      :to => 'users/sessions#sign_in_successful',
      :as => :sign_in_successful
    match 'users/session_current_user',
      :to => 'users/sessions#session_current_user',
      :as => :session_current_user
    post 'sign_up', :to => 'users/registrations#create'
  end

  namespace :user do
    resources :plates
    resources :broadcasts do
      post 'sort' => 'broadcasts#sort', :as => 'sort'
      post 'add/:id' => 'broadcasts#add', :as => 'add'
      post 'remove/:id' => 'broadcasts#remove', :as => 'remove'
    end
    resources :tracks
  end

  resources :plates, :only => [:show, :index] do
    resources :tracks, :controller => 'plates/tracks'
  end

  resources :profiles
  resources :search, :only => [:create, :index]
  resource  :acceptance,
  :controller => 'acceptance',
  :only => [:edit, :update]

  resources :tracks, :only => [:show, :index]

  # This line mounts Refinery's routes at the root of your application.
  # This means, any requests to the root URL of your application will
  # go to Refinery::PagesController#home.
  # If you would like to change where this extension is mounted,
  # simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Refinery relies
  # on it being the default of "refinery"
  mount Refinery::Core::Engine, :at => '/'
end
