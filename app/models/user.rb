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

  def favourite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favourite_style
    return nil if ratings.empty?
    query = 'SELECT style_id, avg(score) AS average FROM ratings LEFT OUTER JOIN beers ON ratings.beer_id = beers.id GROUP BY style_id ORDER BY average DESC'
    style_id = ActiveRecord::Base.connection.execute(query).first['style_id']
    Style.find(style_id)
  end

  def favourite_brewery
    return nil if ratings.empty?
    query = 'SELECT breweries.id, avg(score) AS average FROM ratings LEFT OUTER JOIN beers ON ratings.beer_id = beers.id LEFT OUTER JOIN breweries ON beers.brewery_id = breweries.id GROUP BY breweries.id ORDER BY average DESC'
    favourite_brewery_id = ActiveRecord::Base.connection.execute(query).first['id']
    Brewery.find(favourite_brewery_id)
  end

  def self.most_ratings(number)
    User.joins(:ratings).group('users.id').order('count(ratings.id) DESC').limit(number)
  end

end
