class AddAvailableInventoryToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :available_inventory, :integer, default: :inventory
  end
end
