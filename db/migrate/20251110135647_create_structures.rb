class CreateStructures < ActiveRecord::Migration[8.0]
  def change
    create_table :structures do |t|
      t.references :space, null: false, foreign_key: true
      t.string :name
      t.text :content
      t.integer :status

      t.timestamps
    end
  end
end
