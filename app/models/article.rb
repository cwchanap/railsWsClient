class Article < ApplicationRecord
    has_many :comments, dependent: :delete_all
    validates :title, presence: true, length: { minimum: 5 }
    validates :text, presence: true
end
