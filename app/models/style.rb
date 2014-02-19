class Style < ActiveRecord::Base

  has_many :beers

  validates_presence_of :name

  def to_s
    name
  end

  def average_rating
    if self.beers.size > 0
      self.beers.collect(&:average_rating).compact.sum.to_f / self.beers.size
    else
      0
    end
  end

  def self.top(number)
    all.sort_by{ |s| -(s.average_rating or 0) }.take number
  end
end