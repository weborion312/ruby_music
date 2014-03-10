require 'spec_helper'

describe User::BroadcastsController do
  let(:user) do
    create(:user) do |u|
      u.broadcasts.create(attributes_for(:broadcast))
    end
  end

  before do
    sign_in :user, user
  end

  describe "GET broadcasts/" do
    it "assigns @broadcasts" do
      get :index
      assigns(:broadcasts).should eq(user.broadcasts)
    end

    it "renders the index template" do
      get :index
      response.should render_template("index")
    end
  end

  describe "GET broadcasts/:id"
  describe "GET broadcasts/:id"
  describe "POST broadcasts/new"
  describe "POST broadcasts/:id"
  describe "DELETE broadcasts/:id"

  describe "PUT broadcasts/:id" do
    let!(:broadcast) { user.broadcasts.first }

    describe "with valid params" do
      before do
        put :update, :id => broadcast.id
      end

      it "should find broadcast and return object" do
        assigns(:broadcast).should eq(broadcast)
      end

      it "should redirect to the broadcast's show page" do
        response.should redirect_to('/#!'+edit_user_broadcast_path(broadcast))
      end
    end

    describe "with invalid params" do
      before do
        put :update, :id => 'invalid'
      end

      it "should find broadcast and return object" do
        assigns(:broadcast).should_not eq(broadcast)
      end

      it "should have a flash notice" do
        pending
        flash[:notice].should_not be_blank
      end
    end
  end

  describe 'given a private broadcast'
  it 'should not let a logged-out user access an unpublished broadcast'
  it 'should let a logged-in user access their own unpublished broadcasts'
  describe 'given a public broadcast'
  it 'should let a logged-out user access an unpublished broadcast'
  it 'should let a logged-in user access an unpublished broadcast'
  it 'should record the load of a broadcast'
end
