class Subscription < ApplicationRecord
  belongs_to :subscribable, polymorphic: true
  belongs_to :user
  validates_uniqueness_of :user_id, scope: %i[subscribable_id subscribable_type]
end
