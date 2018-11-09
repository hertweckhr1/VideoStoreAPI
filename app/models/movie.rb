class Movie < ApplicationRecord
  has_many :rentals

  validates :title, presence: true
  validates :overview, presence: true
  validates :release_date, presence: true
  validates :inventory, presence: true

  def available?
    if self.available_inventory > 0
      return true
    else
      return false
    end
  end
end
