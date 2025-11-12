class Structure < ApplicationRecord
  belongs_to :space
  has_many :form_fields
  has_many :answers

  validates_presence_of :name, on: :create, message: "can't be blank"
  validates :token, presence: true, uniqueness: true
  
  before_create :generate_token
  
  private
  
  def generate_token
    self.token = SecureRandom.hex(4)
  end
end
