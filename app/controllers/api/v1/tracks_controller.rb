module Api
  module V1
    class TracksController < ApplicationController

      respond_to :json, :xml

      def index
        respond_with @tracks = Track.public.recent.all
      end

      def show
        respond_with @track = Track.public.find(params[:id])
      end
    end
  end
end
