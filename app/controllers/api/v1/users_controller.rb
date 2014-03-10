module Api
  module V1
    class UsersController < ApplicationController

      respond_to :json, :xml

      def index
        # TODO: Maybe a better #build_users or
        # User.some_filter (like #public)
        respond_with @users = User.all
      end

      def show
        respond_with @user = User.find(params[:id])
      end
    end
  end
end
