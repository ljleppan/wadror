class Brewery < ActiveRecord::Base
  include RatingAverage

  validates_presence_of :name
  validates_presence_of :year
  validates_numericality_of :year, {greater_than_or_equal_to: 1042,
                                    only_integer: true}
  validate :year_not_in_future

  scope :active,  -> { where active:true }
  scope :retired, -> { where active:[nil, false] }

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def year_not_in_future
    unless year.nil?
      if Date.today.year < year
        errors.add(:year, "can't be in the future")
      end
    end
  end

  def self.best(number)
    query = "SELECT * FROM breweries WHERE id IN (SELECT breweries.id FROM ratings LEFT OUTER JOIN beers on ratings.beer_id = beers.id LEFT OUTER JOIN breweries ON beers.brewery_id = breweries.id GROUP BY breweries.id ORDER BY avg(score) DESC) LIMIT #{number}"
    ActiveRecord::Base.connection.execute(query)
  end

  def self.top(number)
    Brewery.joins(:ratings, :beers).group('breweries.id', 'beers.id', 'ratings.id').order('avg(score) DESC').limit(number)
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
    puts "number of ratings #{ratings.count}"
  end

  def restart
    self.year = 2014
    puts "Changer year to #{year}"
  end
end
