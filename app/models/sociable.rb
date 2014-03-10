module Sociable

  def self.included base
    base.extend ClassMethods
  end

  OAUTH_PROVIDERS = %w[twitter facebook myspace]

  def update_omniauth_data(oauth_response)
    update_attribute :avatar_url, oauth_response['info'].try(:[], 'image')
  end

  def register_with_oauth(uid, provider)
    Authentication.create(
                   :user => self,
                   :uid => uid,
                   :provider => provider.to_s
                   )
  end

  def authenticated_providers
    authentications.select(:provider)
      .group(:provider)
      .order(:provider)
      .map do |auth|
      auth.provider
    end
  end

  # Set up an authentication for this new OAuth-instantiated user
  def on_new_oauth!(oauth_response)
    authentications.new(
                    "uid" => oauth_response["uid"],
                    "provider" => oauth_response["provider"]
                    )
    self
  end

  module ClassMethods
    def find_for_oauth(provider, uid)
      User.joins(:authentications)
        .where(["authentications.uid = ?", uid])
        .where(["authentications.provider = ?", provider.to_s])
        .order(:created_at)
        .readonly(false)
        .first
    end

    def twitter_response_hash oauth_response
      {
        :username   => oauth_response["info"]["nickname"],
        :full_name  => oauth_response["info"]["name"],
        :interests  => oauth_response["info"]["description"],
        :avatar_url => (oauth_response["info"]["image"] rescue nil),
        :location   => oauth_response["info"]["location"]
      }
    end

    def facebook_response_hash oauth_response
      {
        :username   => oauth_response["info"]["nickname"],
        :full_name  => oauth_response["info"]["name"],
        :email      => (oauth_response["info"]["email"] rescue nil),
        :avatar_url => (oauth_response["info"]["image"] rescue nil),
        :location   => (oauth_response["extra"]["user_hash"]["location"]["name"] rescue nil),
        :interests  => (oauth_response["extra"]["user_hash"]["bio"] rescue nil)
      }
    end

    def myspace_response_hash oauth_response
      {
        :username   => oauth_response["info"]["nickname"],
        :full_name  => oauth_response["info"]["name"],
        :email      => (oauth_response["info"]["email"] rescue nil),
        :avatar_url => (oauth_response["info"]["image"] rescue nil),
        :location   => (oauth_response["extra"]["user_hash"]["location"]["name"] rescue nil),
        :interests  => (oauth_response["extra"]["user_hash"]["bio"] rescue nil)
      }
    end
  end

  OAUTH_PROVIDERS.each do |provider|
    Sociable::ClassMethods.class_eval %{
      def new_with_#{provider}_session(params, oauth_response)
        begin
          User.new(
               HashWithIndifferentAccess
                 .new(#{provider}_response_hash(oauth_response))
                    .merge(params)
                  )
             rescue
               User.new # TODO log this somewhere
             end
      end
    }
  end
end
