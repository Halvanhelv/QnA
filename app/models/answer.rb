# frozen_string_literal: true

class Answer < ApplicationRecord
  MIN_BODY_LENGTH = 6

  belongs_to :question
  belongs_to :user
  has_many :comments, dependent: :destroy, as: :commentable

  include Linkable
  include Attachable
  include Votable
  include Searchable

  has_rich_text :body
  searchable_by rich_text: :body

  after_create_commit :broadcast_creation, :send_notification
  after_update_commit :broadcast_changes
  after_destroy_commit :broadcast_removal

  validates :body, presence: true
  validate :body_long_enough

  scope :best, -> { where(best_answer: true) }
  scope :order_by_best, -> { order(best_answer: :desc) }

  def make_best_answer
    Answer.transaction do
      user.id == question.reward&.user&.id && id == question.best_answer&.id ? question.reward&.update!(user: nil) : question.reward&.update!(user: user)
      question.best_answer&.update!(best_answer: false)
      update!(best_answer: true)
    end
    question.broadcast_answers
  end

  private

  def body_long_enough
    return if body.blank? || plain_body.length >= MIN_BODY_LENGTH

    errors.add(:body, :too_short, count: MIN_BODY_LENGTH)
  end

  def broadcast_creation
    broadcast_append_to question, target: 'answers', partial: 'answers/answer', locals: { answer: self }
  end

  def broadcast_changes
    broadcast_replace_to question, target: self, partial: 'answers/answer', locals: { answer: self }
  end

  def broadcast_removal
    broadcast_remove_to question
  end

  def send_notification
    NewAnswerNotificationJob.perform_later(self) if question.subscriptions.exists?
  end
end
