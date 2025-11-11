class CreateAnswers < ActiveRecord::Migration[8.0]
  def change
    create_table :answers do |t|
      t.references :structure, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.json :form_data,  default: {}
      t.integer :status
      t.boolean :stared

      t.timestamps
    end
  end
end
