# frozen_string_literal: true

class BestAnswerColumn < ActiveRecord::Migration[6.0]
  def change
    add_column(:answers, :best_answer, :boolean, default: false)
  end
end
