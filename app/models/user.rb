class User < ApplicationRecord
    has_many :articles
    has_many :comments
    validates :username, presence: true, length: { minimum: 8, message: "username must be at least %{count} characters long" }
    validates :password, presence: true, length: { minimum: 8, message: "password must be at least %{count} characters long" }
end
