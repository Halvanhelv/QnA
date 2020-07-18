# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy
  belongs_to :user

  accepts_nested_attributes_for :links, reject_if: :all_blank

  has_many_attached :files

  validates :body, :title, presence: true

  def best_answer
    answers.best.first
  end

end
