class User < Refinery::Core::BaseModel

  include Gravtastic
  extend FriendlyId
  include Sociable

  has_paper_trail

  mount_uploader :avatar, AvatarUploader

  validates_uniqueness_of :username, :case_sensitive => false

  friendly_id :username, :use => :slugged

  is_gravtastic :default => 'identicon'

  scope :recent, order(arel_table[:created_at].desc)

  has_many   :broadcasts
  has_many   :tracks, :dependent => :delete_all
  has_many   :authentications
  belongs_to :terms_and_conditions

  devise :database_authenticatable,
  :registerable,
  :recoverable,
  :rememberable,
  :trackable,
  :omniauthable,
  :validatable,
  :confirmable

  before_create :set_terms_and_conditions_to_current

  attr_accessible :email,
  :password,
  :password_confirmation,
  :remember_me,
  :active,
  :terms_and_conditions_accepted,
  :full_name,
  :location,
  :interests,
  :age_accepted,
  :username,
  :birth_date,
  :avatar_url, # TODO: rm
  :username,
  :avatar,
  :remote_avatar_url,
  :avatar_cache,
  :remove_avatar

  validates :terms_and_conditions_accepted,
  :on => :create,
  :acceptance => {
    :allow_nil => false,
    :message => "You must agree to the terms and conditions"
  }

  validates :age_accepted,
  :on => :create,
  :acceptance => {
    :accept => true,
    :allow_nil => false,
    :message => "You must be the right age"
  }

  validates :username, :presence => true, :uniqueness => true

  def active_avatar_url
    no_img = '/assets/design/no_image_icon.png'
    if self.avatar.blank?
      if self['avatar_url']
        self['avatar_url']
      else
        (Rails.env.test? || Rails.env.development?) ? no_img : self.gravatar_url
      end
    else
      self.avatar.img128.url
    end
  end

  def active_for_authentication?
    super && active?
  end

  def current_tc?
    terms_and_conditions == TermsAndConditions.current
  end

  # This is called in registrations#new by the default Devise
  # implementation. To customize Devise we override it.
  def self.new_with_session(params, session)
    if oauth_response = session[:oauth_response]
      case oauth_response["provider"]
      when "twitter"
        user = self.new_with_twitter_session(params, oauth_response)
        user.on_new_oauth!(oauth_response)
      when "facebook"
        user = self.new_with_facebook_session(params, oauth_response)
        user.on_new_oauth!(oauth_response)
      when "myspace"
        user = self.new_with_myspace_session(params, oauth_response)
        user.on_new_oauth!(oauth_response)
      else
        new(params)
      end
    else
      new(params)
    end
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def display_name
    full_name || username
  end
  alias_method :to_s, :display_name

  def as_json(opt={})
    {
      :id                => self.id,
      :username          => self.username,
      :tracks            => self.tracks,
      :active_avatar_url => self.active_avatar_url
    }
  end

  private

  def set_terms_and_conditions_to_current
    self.terms_and_conditions = TermsAndConditions.current
  end
end
