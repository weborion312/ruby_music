class TermsAndConditions < ActiveRecord::Base

  attr_accessible :notes, :content, :active

  has_paper_trail

  def self.current
    order("created_at DESC, id DESC")
      .where(:active => true)
      .first
  end

end
