class ProfilesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :not_implemented]

  def show
    @profile = User.find_by_slug(params[:id]) if params[:id]
    @providers = current_user.authenticated_providers if current_user
  end

  def edit
    @user = current_user
  end

  def update
    if current_user.update_attributes(params[:user])
      redirect_to '#!/profiles/' + current_user.slug
    else
      redirect_to '#!' + edit_profile_path(current_user)
    end
  end

  def not_implemented
  end

  def recent_tracks
    @recent_tracks ||= @profile.tracks.recent.all
  end
  helper_method :recent_tracks
end
