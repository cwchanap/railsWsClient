require "base64"
require "openssl"

module Crypto
    def encrypt(data)
        secret = Rails.application.config_for :secrets

        cipher = OpenSSL::Cipher::AES128.new(:CBC).encrypt
        cipher.key = Base64.decode64(secret['aes_key'])
        cipher.iv = Base64.decode64(secret['aes_iv'])
    
        encrypted = cipher.update(data) + cipher.final
    end

    def decrypt(data)
        secret = Rails.application.config_for :secrets

        decipher = OpenSSL::Cipher::AES128.new(:CBC).decrypt
        decipher.key = Base64.decode64(secret['aes_key'])
        decipher.iv = Base64.decode64(secret['aes_iv'])
    
        decrypted = decipher.update(data) + decipher.final
    end
end