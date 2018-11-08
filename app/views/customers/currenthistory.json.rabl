collection @rentals

attributes :checkout_date, :due_date

child :movie do
  attributes :title
end
