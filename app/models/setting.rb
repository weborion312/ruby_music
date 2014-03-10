class Setting < ActiveRecord::Base
  DEFAULTS = {
    :wall_percentage_track => 90,
    :wall_percentage_user => 10
  }

  validates :wall_percentage_track, :wall_percentage_user, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }

  def self.instance
    first || new
  end

  before_validation :ensure_one_record
  after_initialize :set_default_values

  protected

  def ensure_one_record
    if self.class.uncached { self.class.count } > 0 then
      errors.add :base, 'cannot have more than one record'
    end
  end

  def set_default_values
    DEFAULTS.each do |key, value|
      send "#{key}=", value if send(key).blank?
    end
  end
end
