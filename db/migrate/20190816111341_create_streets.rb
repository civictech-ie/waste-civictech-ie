class CreateStreets < ActiveRecord::Migration[6.0]
  def change
    create_table :streets do |t|
      t.text :name
      t.text :slug
      t.text :postcode
      t.boolean :bag_street, default: false

      t.timestamps
    end

    add_index :streets, :name, unique: false
    add_index :streets, :slug, unique: true
    add_index :streets, :postcode, unique: false
    add_index :streets, :bag_street, unique: false
  end
end
