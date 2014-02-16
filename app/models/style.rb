class Style < ActiveRecord::Base
  has_many :beers

  validates_presence_of :name

  def to_s
    name
  end
end
