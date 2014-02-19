class BeerClub < ActiveRecord::Base

  has_many :memberships
  has_many :users, through: :memberships

  validates_presence_of :name, :founded, :city

  def member?(user)
    users.include? user and memberships.find_by(user_id:user.id).confirmed
  end
end
