require 'spec_helper'

describe User::TracksController do
  let(:user)  { User.make! }
  let(:track) { Track.make!(:user => user) }

  describe 'excluding pulled tracks' do
    let(:pulled_track) { Track.make!(:pulled => true) }

    describe 'user is logged in' do
      before do
        sign_in :user, user
        pulled_track.update_attribute(:user, user)
      end

      it 'should not allow editing of a pulled track' do
        lambda {
          get :edit, :id => pulled_track.id
          response.should redirect_to root_url + "#!" + user_tracks_path
        }.should_not change(Track, :count)
      end

      it 'should not allow updating of a pulled track' do
        lambda {
          put :update, :track => {}, :id => pulled_track.id
          response.should redirect_to root_url + "#!" + user_tracks_path
        }.should_not change(Track, :count)
      end

      it 'should not allow deleting of a pulled track' do
        lambda {
          delete :destroy, :id => pulled_track.id
          response.should redirect_to root_url + "#!" + user_tracks_path
        }.should_not change(Track, :count)
      end
    end
  end

  describe 'editing tracks' do
    before do
      sign_in :user, user
      put :update, :track => { :name => 'foo', :artist => 'bar', :description => 'baz' }, :id => track.id
    end

    subject { track.reload }

    it 'should have the updated name' do
      subject.name.should == 'foo'
    end

    it 'should have the updated artist' do
      subject.artist.should == 'bar'
    end

    it 'should have the updated description' do
      subject.description.should == 'baz'
    end
  end
end
