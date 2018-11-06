object @rental

node(:errors) { |rental|
  rental.errors.messages
}
