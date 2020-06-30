# frozen_string_literal: true

class CreateQuestionUserReference < ActiveRecord::Migration[6.0]
  def change
    add_reference(:questions, :user, foreign_key: true, on_delete: :cascade)
  end
end
