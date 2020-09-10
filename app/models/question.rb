# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user, dependent: :destroy
  belongs_to :user
  has_many :comments, dependent: :destroy, as: :commentable

  after_save :publish_question
  after_create :create_subscription



  include Linkable
  include Attachable
  include Votable

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :body, :title, presence: true

  def best_answer
    answers.best.first
  end

  def subscribed?(user)
    subscriptions.exists?(user: user)
  end

  def subscription(user)
    subscriptions.find_by(user: user)
  end

  private

  def publish_question
    ActionCable.server.broadcast('questions',
                                 id: id,
                                 title: title)
  end

  def create_subscription
    subscriptions.create(user_id: user_id, question_id: self)
  end
end
