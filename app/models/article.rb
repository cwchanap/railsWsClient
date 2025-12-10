class Article < ApplicationRecord
  belongs_to :user, optional: true
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { minimum: 5 }
  validates :text, presence: true

  # Scopes for article status
  scope :published, -> { where(status: true) }
  scope :draft, -> { where(status: false) }

  # Default scope ordering (optional)
  default_scope { order(created_at: :desc) }
end
