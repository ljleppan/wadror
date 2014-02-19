class Rating < ActiveRecord::Base

  validates_numericality_of :score, {greater_than_or_equal_to: 1,
                                     less_than_or_equal_to: 50,
                                     only_integer: true}

  belongs_to :beer, touch:true
  belongs_to :user, touch:true

  scope :recent,  -> { order(created_at: :desc).limit(5) }

  def to_s
    "#{self.beer.name} #{self.score}"
  end
end
