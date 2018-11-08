class Movie < ApplicationRecord
  has_many :rentals
  has_many :customers, through: :rentals

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
