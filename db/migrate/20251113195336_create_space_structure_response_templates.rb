class CreateSpaceStructureResponseTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :response_templates do |t|
      t.references :structure, null: false, foreign_key: true
      t.integer :status
      t.string :subject
      t.text :content_html
      t.text :content_text
      t.boolean :enabled, default: false

      t.timestamps
    end
  end
end
