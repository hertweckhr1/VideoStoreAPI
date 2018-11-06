object @rental

attributes :checkout_date, :due_date

child :movie do
  attributes :title
end

child :customer do
  attributes :name
end
