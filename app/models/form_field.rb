class FormField < ApplicationRecord
  # Associations
  belongs_to :structure

  enum :field_type, [:string, :text, :boolean, :attachment]
end
