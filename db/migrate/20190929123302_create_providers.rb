class CreateProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :providers do |t|
      t.text :name, null: false
      t.text :slug, null: false

      t.timestamps
    end

    add_index :providers, :slug, unique: true
  end
end
