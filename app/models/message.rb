class Message < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :structure
  belongs_to :answer

  broadcasts_to :answer

  validates :author, :answer, :structure, :content, presence: true

  after_create :send_notification

  def edited?
    created_at != updated_at
  end

  private

  def send_notification
    answer.send_notification(self)
  end
end
