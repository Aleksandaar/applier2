class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :structure, null: false, foreign_key: true
      t.references :answer, null: false, foreign_key: true
      t.text :content, null: false
      t.timestamps

      t.index [:structure_id, :answer_id, :created_at]
    end
  end
end
