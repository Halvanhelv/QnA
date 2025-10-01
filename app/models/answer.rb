# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question, touch: true
  belongs_to :user
  has_many :comments, dependent: :destroy, as: :commentable

  after_commit :publish_answer, :send_notification

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
      question.best_answer&.update!(best_answer: false)
      update!(best_answer: true)
    end
  end

  private

  def publish_answer
    ActionCable.server.broadcast("answers_for_question_#{question.id}", {
                                   author: user.email,
                                   rating: rating,
                                   links: links,
                                   answer: self
                                 })
  end

  def send_notification
    NewAnswerNotificationJob.perform_later(self) if question.subscriptions.exists?
  end
end
