class EventLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :track

  validates :event_type, :inclusion => [:track_play]

  # TODO check security
  attr_accessible :user, :track, :ip, :event_type

  def self.log_track track, user, remote_ip
    if track.public? || track.user == user
      create(
      :user => user,
      :track => track,
      :ip => remote_ip,
      :event_type => :track_play)
    end
  end
end
