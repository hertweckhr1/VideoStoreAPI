object @movie

if @movie.nil?
  node(:ok) { false }
  node(:message) { "not found" }
else
  node(:ok) { true }
  attributes :id, :title, :overview, :release_date, :inventory

  # child :rentals do
  #   attributes :id, :checkout_date, :due_date
  # end
  #
  # child :customers do
  #   attributes :id, :name
  # end
end
