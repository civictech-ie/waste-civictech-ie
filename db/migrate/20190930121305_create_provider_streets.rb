class CreateProviderStreets < ActiveRecord::Migration[6.0]
  def change
    create_table :provider_streets do |t|
      t.references :street, null: false, foreign_key: true
      t.references :provider, null: false, foreign_key: true
      t.integer :collection_start
      t.integer :collection_duration
      t.text :collection_days, array: true, default: []
      t.integer :presentation_start
      t.integer :presentation_duration
      t.text :presentation_days, array: true, default: []

      t.timestamps
    end
  end
end
