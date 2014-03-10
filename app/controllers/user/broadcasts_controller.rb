class User::BroadcastsController < ApplicationController

  before_filter :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to root_url + "#!" + user_broadcasts_path
  end

  def index
    @broadcasts = current_user.broadcasts
  end

  def new
    @broadcast = current_user.broadcasts.build
  end

  def create
    @broadcast = current_user.broadcasts.build(params[:broadcast])
    if @broadcast.save
      flash[:alert] = "Broadcast #{@broadcast.title} created"
      redirect_to root_url + "#!" + edit_user_broadcast_path(@broadcast)
    else
      redirect_to root_url + "#!" + new_user_broadcast_path
    end
  end

  def show
    @broadcast = current_user.broadcasts.find(params[:id])
  end

  def edit
    @broadcast = current_user.broadcasts.find(params[:id])
  end

  def update
    @broadcast = current_user.broadcasts.find(params[:id])
    if @broadcast.update_attributes(params[:broadcast])
      flash[:alert] = "Broadcast #{@broadcast.title} was updated"
      redirect_to root_url + "#!" + edit_user_broadcast_path(@broadcast)
    else
      redirect_to root_url + "#!" + edit_user_broadcast_path(@broadcast)
    end
  end

  def destroy
    @broadcast = current_user.broadcasts.editable.find(params[:id])
    if @broadcast.destroy
      flash[:alert] = "Broadcast #{@broadcast.title} was deleted"
      redirect_to root_url + "#!" + user_broadcasts_path
    else
      redirect_to root_url + "#!" + edit_user_broadcast_path(@broadcast)
    end
  end

  def sort
    broadcast = Broadcast.find(params[:broadcast_id])
    params[:track].each_with_index do |id, index|
      broadcast.tracks.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end

  def add
    broadcast = Broadcast.find(params[:broadcast_id])
    track = Track.find(params[:id])
    broadcast.tracks << track unless broadcast.tracks.include? track
    broadcast.save
    render nothing: true
  end

  def remove
    # TODO: handle not found error
    BroadcastTrack.where(
                   :broadcast_id => params[:broadcast_id],
                   :track_id => params[:id]).last.delete
    render nothing: true
  end

  def recent_broadcasts
    @recent_broadcasts ||= current_user.broadcasts.recent.all
  end
  helper_method :recent_broadcasts
end
