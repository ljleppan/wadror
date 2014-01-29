class User < ActiveRecord::Base
  include RatingAverage

  validates_uniqueness_of :username
  validates_length_of :username, {minimum: 3, maximum: 15}
  validates_length_of :password, minimum: 4
  validates_format_of :password, with: /[A-Z]/
  validates_format_of :password, with: /[0-9]/

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships

end
