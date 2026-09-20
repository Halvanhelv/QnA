# frozen_string_literal: true

# An answer the question author picked as the best one. The record says when it happened.
class Answer::Acceptance < ApplicationRecord
  belongs_to :answer, touch: true
  belongs_to :question, default: -> { answer.question }
end
