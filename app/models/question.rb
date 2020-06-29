class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  validates :body, :title, presence: true
end
