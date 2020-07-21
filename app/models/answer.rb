# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  has_many_attached :files

  validates :body, presence: true
  validates :body, length: { minimum: 6 }

  scope :best, -> { where(best_answer: true) }
  scope :order_by_best, -> { order(best_answer: :desc) }

  def make_best_answer
    Answer.transaction do
    question.best_answer&.update!(best_answer: false)  # если попытаться сделать один и тот же ответ лучшим два раза то это строка уберет статус лучшего ответа
    update!(best_answer: true)                         # и поскольку текущий вопрос еще находится в памяти то при выполнении кода обращение к бд не будет поскольку виртуально ответ уже лучший и попытка сделать его снова лушчим вернет просто true
    question.reward&.update!(user: user)
    end
  end
end
