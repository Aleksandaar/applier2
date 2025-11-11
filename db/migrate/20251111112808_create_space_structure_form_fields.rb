class CreateSpaceStructureFormFields < ActiveRecord::Migration[8.0]
  def change
    create_table :form_fields do |t|
      t.references :structure, null: false, foreign_key: true
      t.integer :field_type
      t.integer :position
      t.boolean :required

      t.timestamps
    end
  end
end
