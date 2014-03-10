ActiveAdmin.register Track do
  belongs_to :user, :optional => true

  scope :all, :default => true
  scope :public
  scope :private
  scope :pulled

  index do
    id_column
    column :name
    column :plays
    column 'Owner', :user
    column :private
    column 'Media Name', :sortable => :media_file_name do |t|
      link_to t.name, t.mp3.url
    end
    column 'Media Type', :media_content_type
    column 'Media Size', :sortable => :media_file_size do |t|
      number_to_human_size(t.mp3.size)
    end
    column 'Media Updated At', :media_updated_at
    column :created_at
    column :updated_at
    column :plays
    column :pulled
    column :pulled_at
    column :pulled_reason

    # this is a kludged connection due to the user variable not existing if 'optional' is set for the relationship
    # optional is required, so that all tracks may be displayed (and thus all tracks searched on)
    column '', :sortable => false do |t|
      link_name = t.pulled? ? 'Restore' : 'Pull'
      link_to link_name, "/admin/tracks/#{t.id}/pull_or_restore_form"
    end

    default_actions
  end

  form :html => { :multipart => true } do |f|
    f.inputs 'Details' do
      f.input :name
      f.input :user, :label => 'Owner'
      f.input :media
    end
    f.action :submit
  end

  collection_action :pull_user_tracks, :method => :put do
    user = User.find(params[:user_id])
    user.tracks.each(&:pull!)
    redirect_to admin_user_url(user), :notice => 'All tracks pulled'
  end

  member_action :pull_or_restore_form do
    @track = Track.find(params[:id])
    @page_title = @track.pulled? ? 'Restore Track' : 'Pull Track'
  end

  member_action :pull_or_restore, :method => :post do
    track = Track.find(params[:id])

    track.pulled_reason = params[:track][:pulled_reason]
    track.toggle_pulled!

    redirect_to :action => :show, :notice => track.pulled? ? 'Pulled!' : 'Restored!'
  end
end
