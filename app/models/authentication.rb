class Authentication < ActiveRecord::Base
  belongs_to :user

  # TODO - Double check this isn't a security issue
  attr_accessible :uid, :provider, :user
end
