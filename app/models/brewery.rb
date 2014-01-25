class Brewery < ActiveRecord::Base
  include RatingAverage

  validates_presence_of :name
  validates_numericality_of :year, {greater_than_or_equal_to: 1042,
                                    only_integer: true}
  validate :year_not_in_future

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def year_not_in_future
    if year > Date.today.year
      errors.add(:year, "can't be in the future")
    end
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
