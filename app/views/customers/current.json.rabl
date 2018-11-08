collection @rentals
attributes :checkout_date, :due_date

child :movie do
  condition = lambda {|child| child.checkin_date == nil}
  attributes :checkout_date, :due_date, :if => condition
end
