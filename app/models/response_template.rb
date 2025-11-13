class ResponseTemplate < ApplicationRecord
  # Associations
  belongs_to :structure

  # Status - must match statuses from the Answer model
  enum :status, [:accepted, :rejected, :archived, :spam, :process, :closed, :ignored]

  # Validations
  validates :subject, presence: true
  validates :content_html, presence: true
  validates :content_text, presence: true
end
