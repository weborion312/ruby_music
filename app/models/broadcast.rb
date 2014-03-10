class Broadcast < ActiveRecord::Base

  belongs_to :user
  has_many :broadcast_tracks
  has_many :tracks, :through => :broadcast_tracks, :uniq => true, :dependent => :nullify

  mount_uploader :image, ImageUploader

  attr_accessible :title,
  :image,
  :image_cache,
  :remove_image,
  :description,
  :track_ids

  scope :recent, order("created_at DESC")
end
