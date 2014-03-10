class TracksController < ApplicationController

  # TODO: delete
  # def index
  #   @tracks = Track.public
  # end

  def show
    @track = Track.public.find(params[:id])
    respond_to do |format|
      format.html
      [:mp3, :oga].each {|type| format.send(type) {send_audio(type)}}
    end
  end

  private

  def send_audio type
    EventLog.log_track(@track, current_user, request.remote_ip)
    send_file(@track.send(type).high.path, :type => (type == :mp3 ? 'audio/mpeg' : 'audio/ogg'))
  end
end
