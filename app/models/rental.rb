class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :movie

  validates :checkout_date, presence: true
  validates :due_date, presence: true

  def self.create_rental(customer, movie)
    return Rental.new(customer: customer, movie: movie,
      checkout_date: Date.current, due_date: Date.current + 7)
  end

  def check_out_transaction(customer, movie)
    movie.available_inventory -= 1
    movie.save
    customer.movies_checked_out_count += 1
    customer.save
  end

  def check_in_transaction(customer, movie)
    self.checkin_date = DateTime.current
    movie.available_inventory += 1
    movie.save
    customer.movies_checked_out_count -= 1
    customer.save
    self.save
  end
end
