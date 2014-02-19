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

  def self.top(number)
    all.sort_by{ |b| -(b.average_rating or 0) }.take number
  end
end
