class BroadcastsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to broadcasts_url
  end

  # TODO: Broadcast#public scope

  def index
    @broadcasts = Broadcast.all
  end

  def show
    @broadcast = Broadcast.find(params[:id])
  end
end
