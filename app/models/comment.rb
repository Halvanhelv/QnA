class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true, length: { minimum: 10 }

  default_scope { order(:created_at) }
end
