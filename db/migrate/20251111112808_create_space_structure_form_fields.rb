class CreateSpaceStructureFormFields < ActiveRecord::Migration[8.0]
  def change
    create_table :form_fields do |t|
      t.references :structure, null: false, foreign_key: true
      t.string :label
      t.integer :field_type, default: 0
      t.integer :position, default: 0
      t.boolean :required, default: false

      t.timestamps
    end
  end
end
