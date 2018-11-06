class AddCheckInDateToRental < ActiveRecord::Migration[5.2]
  def change
    add_column :rentals, :checkin_date, :date
  end
end
