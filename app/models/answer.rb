# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :comments, dependent: :destroy, as: :commentable

  after_save :publish_answer

  include Linkable
  include Attachable
  include Votable

  validates :body, presence: true
  validates :body, length: { minimum: 6 }

  scope :best, -> { where(best_answer: true) }
  scope :order_by_best, -> { order(best_answer: :desc) }

  def make_best_answer
    Answer.transaction do
      user.id == question.reward&.user&.id && id == question.best_answer&.id ? question.reward&.update!(user: nil) : question.reward&.update!(user: user)
      question.best_answer&.update!(best_answer: false)  # если попытаться сделать один и тот же ответ лучшим два раза то это строка уберет статус лучшего ответа
      update!(best_answer: true)                         # и поскольку текущий вопрос еще находится в памяти то при выполнении кода обращение к бд не будет поскольку виртуально ответ уже лучший и попытка сделать его снова лушчим вернет просто true
    end
  end

  private

  def publish_answer
    ActionCable.server.broadcast("answers_for_question_#{question.id}",
                                 author: user.email,
                                 rating: rating,
                                 links: links,
                                 answer: self)
  end
end
