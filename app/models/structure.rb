class Structure < ApplicationRecord
  belongs_to :space
  has_many :form_fields
end
