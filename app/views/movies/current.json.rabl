collection @rentals

node(:ok) { true }
attributes :checkout_date, :due_date

child :customer do
  attributes :id, :name, :postal_code
end
