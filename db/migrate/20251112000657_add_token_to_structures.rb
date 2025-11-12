class AddTokenToStructures < ActiveRecord::Migration[8.0]
  def change
    add_column :structures, :token, :string
    add_index :structures, :token, unique: true
  end
end
