class Beer < ActiveRecord::Base
  include RatingAverage

  validates_presence_of :name, :style_id

  belongs_to :brewery, touch:true
  belongs_to :style, touch:true
  has_many :ratings, dependent: :destroy
  has_many :raters, -> {uniq}, through: :ratings, source: :user

  def to_s
    "#{self.name} (#{self.brewery.name})"
  end

  def self.with_best_average(number)
    query = "SELECT * FROM users WHERE id IN (SELECT user_id FROM ratings GROUP BY user_id ORDER BY count(*) DESC LIMIT #{number})"
    ActiveRecord::Base.connection.execute(query)
  end

  def self.top(number)
    Beer.joins(:ratings).group('beers.id', 'ratings.id').order('avg(score) DESC').limit(number)
  end
end
