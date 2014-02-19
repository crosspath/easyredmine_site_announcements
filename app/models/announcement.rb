class Announcement < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :title, :message, :starts_at, :ends_at

  validates :title, :starts_at, :ends_at, presence: true
  validate :ends_at_cannot_be_in_the_past, on: :create

  def self.current(hidden_ids = nil)
    result = where(":now between starts_at and ends_at", now: Time.zone.now)
    result = result.where("id not in (?)", hidden_ids) if hidden_ids.present?
    result
  end

  def ends_at_cannot_be_in_the_past
    unless ends_at.present? && ends_at > Time.zone.now
      errors.add :ends_at, "can't be in the past"
    end
  end
end