require "base64"

class SignUpMailer < ApplicationMailer
  include Crypto
  default :from => "helloworld"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.sign_up_mailer.validate_email.subject
  #
  def validate_email(username, address, host)
    @username = username

    encrypted = encrypt(username)

    @validate_link = "http://#{host}/validate?key=#{Base64.encode64(encrypted)}".gsub('+', '%2B')

    mail to: address
  end
end
