require "base64"
require "openssl"

module Crypto
  extend ActiveSupport::Concern

  included do
    # Access encryption methods
  end

  def encrypt(data)
    credentials = Rails.application.credentials

    cipher = OpenSSL::Cipher.new("aes-128-cbc").encrypt
    cipher.key = Base64.decode64(credentials.dig(:crypto, :aes_key))
    cipher.iv = Base64.decode64(credentials.dig(:crypto, :aes_iv))

    cipher.update(data) + cipher.final
  end

  def decrypt(data)
    credentials = Rails.application.credentials

    decipher = OpenSSL::Cipher.new("aes-128-cbc").decrypt
    decipher.key = Base64.decode64(credentials.dig(:crypto, :aes_key))
    decipher.iv = Base64.decode64(credentials.dig(:crypto, :aes_iv))

    decipher.update(data) + decipher.final
  end
end
