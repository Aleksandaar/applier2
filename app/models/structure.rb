class Structure < ApplicationRecord
  # Associations
  belongs_to :space
  has_many :form_fields
  has_many :response_templates
  has_many :answers

  enum :status, [ :active, :archived ]

  # Validations
  validates_presence_of :name, on: :create, message: "can't be blank"
  validates :token, presence: true, uniqueness: true, on: :create

  # Callbacks
  before_validation :ensure_token

  private
  
  def ensure_token
    if token.blank?
      self.token = SecureRandom.hex(4)
    end
  end
end
