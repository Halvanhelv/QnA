# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  has_many_attached :files

  validates :body, :title, presence: true

  def best_answer
    answers.best.first
  end

end
