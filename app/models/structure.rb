class Structure < ApplicationRecord
  belongs_to :space
  has_many :form_fields
  has_many :answers

  validates_presence_of :name, on: :create, message: "can't be blank"
end
