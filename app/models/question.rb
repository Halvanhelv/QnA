# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy

  after_save :publish_question
  after_create :create_subscription

  belongs_to :user
  has_many :comments, dependent: :destroy, as: :commentable

  include Linkable
  include Attachable
  include Votable
  include Subscribable

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :body, :title, presence: true

  def best_answer
    answers.best.first
  end

  private

  def publish_question
    ActionCable.server.broadcast('questions',
                                 id: id,
                                 title: title)
  end

  def create_subscription
    subscriptions.create(user_id: user_id, subscribable: self)
  end
end
