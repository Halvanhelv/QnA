# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :user_id, uniqueness: { scope: :question_id }
end
