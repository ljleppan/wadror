class Style < ActiveRecord::Base
  has_many :beers

  validates_presence_of :name

  def to_s
    name
  end

  def self.top(number)
    Style.joins(:beers => :ratings).group('styles.id').order('avg(score) DESC').limit(number)
  end
end