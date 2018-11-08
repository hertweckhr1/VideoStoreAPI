object @rental

node(:ok) { false }
node(:errors) { |rental|
  rental.errors.messages
}
