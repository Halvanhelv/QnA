# frozen_string_literal: true

class Subscriptions < ActiveRecord::Migration[6.0]
  create_table :subscriptions do |t|
    t.references :user, null: false, foreign_key: true
    t.belongs_to :question, null: false, foreign_key: true # аналог references
    t.index %i[question_id user_id]
    t.timestamps
  end
end
