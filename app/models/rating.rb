class Rating < ActiveRecord::Base

  validates_numericality_of :score, {greater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 50,
                                     only_integer: true}

  belongs_to :beer
  belongs_to :user

  def to_s
    "#{self.beer.name} #{self.score}"
  end
end
