module Api
  module V1
    class BroadcastsController < ApplicationController

      respond_to :json, :xml

      def index
        respond_with @broadcasts = Broadcast.all
      end

      def show
        respond_with @broadcast = Broadcast.find(params[:id])
      end
    end
  end
end
