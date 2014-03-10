require 'spec_helper'

describe TracksController do
  let(:user)  { User.make! }
  let(:track) { Track.make!(:user => user) }

  describe 'excluding pulled tracks' do
    let(:pulled_track) { Track.make!(:pulled => true) }

    it 'should not find a pulled track when index' do
      pending 'ATM there is no track index action.'
      get :index
      assigns(:tracks).should_not include(pulled_track)
    end

    it 'should not find a pulled track when show' do
      get :show, :id => pulled_track.id
      response.status.should == 404
    end

    it 'should not allow downloading from a pulled track' do
      pending 'Pulled track logic not implemented'
      get :show, :id => pulled_track.id, :extension => 'oga'
      response.status.should == 404
    end
  end

  describe 'given a private track' do
    before :each do
      track.stub(:public?).and_return(false)
      Track.stub(:find).and_return(track)
    end

    it 'should not let a logged-out user access an unpublished mp3' do
      pending 'Private track logic not implemented'
      get :show, :id => track.id, :extension => 'oga'
      response.status.should == 404
    end

    it 'should let a logged-in user access their own unpublished mp3' do
      pending 'Private track logic not implemented'
      sign_in :user, user
      get :download, :id => track.id, :style => 'oga', :extension => 'oga'
      response.should be_success
      response.should_not be_redirect
    end
  end

  describe 'given a public track' do
    before :each do
      track.stub(:public?).and_return(true)
    end

    it 'should let a logged-out user access an unpublished mp3' do
      get :show, :id => track.id, :extension => 'oga'
      response.should be_success
      response.should_not be_redirect
    end

    it 'should let a logged-in user access an unpublished mp3' do
      sign_in :user, user
      get :show, :id => track.id, :extension => 'oga'
      response.should be_success
      response.should_not be_redirect
    end

    it 'should record the load of a track' do
      pending 'Move to an integration spec.'
      sign_in :user, user
      request.stub!(:remote_ip).and_return('192.168.0.111')
      EventLog.should_receive(:create).with(:user => user, :track => track, :event_type => :track_play, :ip => '192.168.0.111')
      get :show, :id => track.id, :extension => 'oga'
    end
  end
end
