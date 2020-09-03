module Subscribable
  extend ActiveSupport::Concern
  included do
    has_many :subscriptions, dependent: :destroy, as: :subscribable
    has_many :subscribers, through: :subscriptions, source: :user, dependent: :destroy
  end
end
