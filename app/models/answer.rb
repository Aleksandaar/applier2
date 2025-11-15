class Answer < ApplicationRecord
  # Associations
  belongs_to :user, optional: true
  belongs_to :structure
  has_many :messages

  store :form_data, coder: JSON
  # has_one_attached :attachment

  # Status
  enum :status, [:accepted, :rejected, :archived, :spam, :process, :closed, :ignored]
  
  validate :validate_form_data, on: :create
  validate :validate_attachment, on: :create
  validates :token, presence: true, uniqueness: true
  after_validation :create_or_find_user, on: :create
  
  before_create :generate_token
  after_update :process_emails, if: :saved_change_to_status?

  def send_notification(message)
    if !message.author.admin?  # message.author.simple?
      user = structure.space.users.find_by(admin: true)

      MessageMailer.new_message_admin_notification(self, user).deliver_now!
    else
      MessageMailer.new_message_notification(self, message.answer.user).deliver_now!
    end
  end
  
  private
  
  def validate_form_data
    email = form_data&.dig("email")
    
    # Validate email
    if email.blank?
      errors.add(:form_data, "email is required")
    elsif !email.match?(URI::MailTo::EMAIL_REGEXP)
      errors.add(:form_data, "email is invalid")
    end
    
    # Validate required form fields
    structure.form_fields.where(required: true).each do |field|
      value = form_data&.dig(field.sanitized_label)
      if value.blank? && !field.file?
        errors.add(:form_data, "#{field.label} is required")
      end
    end
  end

  def validate_attachment
    field = structure.form_fields.where(field_type: :file).first

    if field.required && file_data.blank?
      errors.add(:file_data, "#{field.label} is required")
    end

    if file_data.present?
      self.filename = file_data.original_filename
      self.content_type = file_data.content_type
      self.file_data = file_data.read
      # if attachment.byte_size > 5.megabytes
      #   errors.add(:attachment, "is too large (maximum 5MB)")
      # end

      
      # Allowed attachment types
      allowed_types = ["application/pdf", "image/jpeg", "image/png", "application/msword"]
      if !allowed_types.include?(self.content_type)
        errors.add(:file_data, "#{field.label} must be PDF, JPG, PNG, or DOC")
      end
    end
  end
  
  def create_or_find_user
    email = form_data["email"]
    return if email.blank?
    
    user = User.find_by(email: email)
    
    if user.present?
      self.user = user
    else
      # Create new user with generated password
      password = SecureRandom.hex(10)
      user = User.create(
        email: email,
        password: password,
        password_confirmation: password
      )

      if user.persisted?
        self.user = user
        # Optional: Send welcome email with password
        # UserMailer.welcome_email(user, password).deliver_later
      else
        errors.add(:base, "Could not create user: #{user.errors.full_messages.join(', ')}")
        throw :abort
      end
    end
  end

  def process_emails
    response_template = structure.response_templates.find_by(status: status, enabled: true)
    
    if response_template.present?
      ResponseTemplateMailer.response_email(response_template, user).deliver_now!
    end
  end

  def generate_token
    self.token = SecureRandom.hex(8)
  end
end