class AddSeededAtToStreet < ActiveRecord::Migration[6.0]
  def change
    add_column :streets, :seeded_at, :datetime
    add_index :streets, :seeded_at, unique: false
  end
end
