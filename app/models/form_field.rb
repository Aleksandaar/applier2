class FormField < ApplicationRecord
  # Associations
  belongs_to :structure

  enum :field_type, [:string, :text, :boolean, :attachment]

  def sanitized_label
    label.gsub(/[^a-zA-Z0-9\s\-_.]/, "").strip
  end
end
