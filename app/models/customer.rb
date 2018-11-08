class Customer < ApplicationRecord
  has_many :rentals

  validates :name, presence: true
  validates :registered_at, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :postal_code, presence: true
  validates :phone, presence: true

  def overdue_items?
    overdue = self.rentals.select{ |rental| rental.checkin_date == nil &&
      rental.due_date < Date.current }

    if overdue.empty?
      return false
    else
      return true
    end
  end
end
