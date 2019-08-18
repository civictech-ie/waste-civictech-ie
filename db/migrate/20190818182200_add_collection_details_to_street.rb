class AddCollectionDetailsToStreet < ActiveRecord::Migration[6.0]
  def change
    add_column :streets, :collection_days, :text, array: true, default: []
    add_column :streets, :collection_start, :integer
    add_column :streets, :collection_duration, :integer
    add_column :streets, :presentation_days, :text, array: true, default: []
    add_column :streets, :presentation_start, :integer
    add_column :streets, :presentation_duration, :integer
  end
end
