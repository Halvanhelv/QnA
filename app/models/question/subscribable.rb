# frozen_string_literal: true

module Question::Subscribable
  extend ActiveSupport::Concern

  included do
    has_many :subscriptions, dependent: :destroy
    has_many :subscribers, through: :subscriptions, source: :user

    after_create :subscribe_author
  end

  def subscribed?(user)
    subscriptions.exists?(user: user)
  end

  def subscription(user)
    subscriptions.find_by(user: user)
  end

  def subscribe(user)
    subscriptions.find_or_create_by(user: user)
  end

  private

  def subscribe_author
    subscribe(user)
  end
end
