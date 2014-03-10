class User::TracksController < ApplicationController

  before_filter :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to root_url + "#!" + user_tracks_path
  end

  def index
    @tracks = current_user.tracks #.order("position")
  end

  def new
    @track = current_user.tracks.build
  end

  def create
    @track = current_user.tracks.editable.build(params[:track])
    if @track.save
      flash[:alert] = "Track #{@track.name} created"
      redirect_to root_url + "#!" + edit_user_track_path(@track)
    else
      redirect_to root_url + "#!" + new_user_track_path
    end
  end

  def edit
    @track = current_user.tracks.editable.find(params[:id])
  end

  def update
    @track = current_user.tracks.editable.find(params[:id])
    if @track.update_attributes(params[:track])
      flash[:alert] = "Track #{@track.name} was updated"
      redirect_to root_url + "#!" + track_path(@track)
    else
      redirect_to root_url + "#!" + edit_user_track_path(@track)
    end
  end

  def destroy
    @track = current_user.tracks.editable.find(params[:id])
    if @track.destroy
      flash[:alert] = "Track #{@track.name} was deleted"
      redirect_to root_url + "#!" + user_tracks_path
    else
      redirect_to root_url + "#!" + edit_user_track_path(@track)
    end
  end
end
