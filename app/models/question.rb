class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :body, :title, presence: true
end
