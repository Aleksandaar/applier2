class Answer < ApplicationRecord
  # Associations
  belongs_to :user, optional: true
  belongs_to :structure

  store :form_data, coder: JSON
  
  validate :validate_form_data
  after_validation :create_or_find_user
  
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
      if value.blank?
        errors.add(:form_data, "#{field.label} is required")
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
end