class ChangeBagStreetToPresentationMethod < ActiveRecord::Migration[6.0]
  def change
    add_column :streets, :presentation_method, :text, index: true, unique: false, default: 'bin', null: false
    remove_column :streets, :bag_street, :boolean
  end
end
