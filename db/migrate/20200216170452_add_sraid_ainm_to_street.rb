class AddSraidAinmToStreet < ActiveRecord::Migration[6.0]
  def change
    add_column :streets, :sraid_ainm, :text
  end
end
