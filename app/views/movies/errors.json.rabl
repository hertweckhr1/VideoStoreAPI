object @movie

node(:errors) { |movie|
  movie.errors.messages
}
