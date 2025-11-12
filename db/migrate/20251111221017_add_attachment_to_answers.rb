class AddAttachmentToAnswers < ActiveRecord::Migration[8.0]
  def change
    add_column :answers, :file_data, :binary
    add_column :answers, :filename, :string
    add_column :answers, :content_type, :string
  end
end
