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

  def self.top(number)
    all.includes(:ratings).sort_by{ |b| -(b.average_rating or 0) }.take number
  end
end
