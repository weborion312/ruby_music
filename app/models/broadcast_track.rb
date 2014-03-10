class BroadcastTrack < ActiveRecord::Base
  belongs_to :broadcast
  belongs_to :track
end
