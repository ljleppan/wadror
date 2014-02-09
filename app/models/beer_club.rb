class BeerClub < ActiveRecord::Base

  has_many :memberships
  has_many :users, through: :memberships

  validates_presence_of :name, :founded, :city
end
