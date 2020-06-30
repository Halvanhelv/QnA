# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, presence: true
  validates :body, length: { minimum: 6 }
end
