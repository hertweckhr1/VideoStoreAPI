object @rental

attributes :checkout_date, :due_date, :checkin_date

child :movie do
  attributes :title, :available_inventory
end

child :customer do
  attributes :name, :movies_checked_out_count
end
