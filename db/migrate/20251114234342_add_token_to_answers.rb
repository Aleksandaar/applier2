class AddTokenToAnswers < ActiveRecord::Migration[8.0]
  def change
    add_column :answers, :token, :string
    add_index :answers, :token, unique: true
  end
end
