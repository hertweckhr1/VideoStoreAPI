object @movie

node(:ok) { false }
node(:errors) { |movie|
  movie.errors.messages
}
