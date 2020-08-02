class Comment < ApplicationRecord
  default_scope { order(:created_at) }
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true, length: { minimum: 10 }
end
