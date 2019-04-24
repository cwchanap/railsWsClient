# Preview all emails at http://localhost:3000/rails/mailers/sign_up_mailer
class SignUpMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/sign_up_mailer/validate_email
  def validate_email
    SignUpMailer.validate_email
  end

end
