class AddDisplayNameToStreet < ActiveRecord::Migration[6.0]
  def up
    add_column :streets, :display_name, :text
    execute "create index streets_display_name on streets using gin(to_tsvector('english', display_name))"
  end

  def down
    remove_column :streets, :display_name, :text
    execute "drop index streets_display_name"
  end
end
