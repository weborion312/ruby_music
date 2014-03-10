require 'webjam/mp3_metadata'
class Track < ActiveRecord::Base

  extend FriendlyId

  friendly_id :token, :use => :slugged

  has_paper_trail
  acts_as_list

  after_create :set_artwork_url,
  :set_urlsafe_base64_token,
  :process_audio_types

  belongs_to :user
  has_many :event_logs
  has_many :broadcast_tracks
  has_many :broadcasts, :through => :broadcast_tracks, :dependent => :nullify

  attr_accessible :name,
  :artist,
  :description,
  :tags,
  :private,
  :user,
  :user_id,
  :created_at,
  :updated_at,
  :pulled,
  :pulled_at,
  :pulled_reason,
  :duration,
  :artwork,
  :remove_artwork,
  :artwork_cache,
  :remote_artwork_url,
  :media,
  :remove_media,
  :media_cache,
  :remote_media_url,
  :token,
  :mp3,
  :oga

  mount_uploader :media, MediaUploader
  mount_uploader :artwork, ArtworkUploader
  mount_uploader :mp3, MP3Uploader
  mount_uploader :oga, OGAUploader

  before_create :populate_metadata

  scope :recent, order("created_at DESC")
  scope :public, where(:pulled => [false, nil], :private => [false, nil])
  scope :private, where(:private => true)
  scope :pulled, where(:pulled => true)
  scope :editable, where(:pulled => [false, nil])

  validates :media, :presence => true
  validates_presence_of :name, :on => :update

  def plays
    EventLog.where(:track_id => id, :event_type => :track_play).count
  end

  def public?
    !private? && !pulled?
  end

  def publish!
    self.private = false
    save!
  end

  def unpublish!
    self.private = true
    save!
  end

  def pull!
    self.pulled = true
    self.pulled_at = Time.now
    save!
  end

  def toggle_pulled!
    self.pulled = !pulled
    self.pulled_at = Time.now
    save!
  end

  def display_name
    [self.artist, self.name].reject(&:blank?).uniq.join ' - '
  end

  def populate_metadata
    metadata      = WebJam::Mp3Metadata.new(self)
    self.name     = metadata.name
    self.tags     = metadata.tags
    self.artist   = metadata.artist
    self.duration = metadata.duration
  end

  def as_json(opt={})
    {
      :id          => self.id,
      :name        => self.name,
      :slug        => self.slug,
      :description => self.description,
      :media       => self.media,
      :artwork     => self.artwork
    }
  end

  private

  def set_urlsafe_base64_token
    token = ::SecureRandom.urlsafe_base64(8)
    while !Track.find_by_token token
      update_attributes!(:token => token)
    end
  end

  def set_artwork_url
    if self.artwork.blank?
      self.artwork.store!(File.open(Rails.root+'app/assets/images/design/no_image_icon.png'))
    end
  end

  def process_audio_types
    Resque.enqueue(Transcode, self.id)
  end
end
