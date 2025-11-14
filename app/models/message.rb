class Message < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :structure
  belongs_to :answer

  broadcasts_to :answer

  validates :author, :answer, :structure, :content, presence: true

  def edited?
    created_at != updated_at
  end
end
