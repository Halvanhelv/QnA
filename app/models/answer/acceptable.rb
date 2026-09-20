# frozen_string_literal: true

module Answer::Acceptable
  extend ActiveSupport::Concern

  included do
    has_one :acceptance, dependent: :destroy, class_name: 'Answer::Acceptance'

    scope :accepted, -> { joins(:acceptance) }
  end

  def accepted?
    acceptance.present?
  end

  # Replaces the question's previous accepted answer and hands the reward to this answer's author.
  def accept
    return if accepted?

    transaction do
      question.acceptance&.destroy!
      create_acceptance!
      question.reward&.update!(user: user)
    end
    question.broadcast_answers
  end
end
