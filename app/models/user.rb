class User < ApplicationRecord
  # Rails 8 built-in authentication uses has_secure_password
  # This requires bcrypt gem and a password_digest column
  has_secure_password

  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :username, presence: true,
                       length: { minimum: 8, message: "must be at least %<count>s characters long" },
                       uniqueness: { case_sensitive: false }
  validates :email, presence: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8, message: "must be at least %<count>s characters long" },
                       if: -> { new_record? || !password.nil? }

  # Normalize email before saving
  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :username, with: lambda(&:strip)

  # Email validation status
  scope :validated, -> { where(isValidate: true) }
  scope :pending_validation, -> { where(isValidate: false) }
end
