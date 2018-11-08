collection @rentals

node(:ok) { true }
attributes :checkout_date, :due_date

child :movie do
  attributes :title
end
