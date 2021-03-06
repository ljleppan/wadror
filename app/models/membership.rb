class Membership < ActiveRecord::Base

  validates_uniqueness_of :beer_club_id, :scope => [:user_id]

  belongs_to :beer_club
  belongs_to :user

  scope :confirmed, -> {where confirmed: true}
  scope :unconfirmed, -> {where.not confirmed: true}

end
