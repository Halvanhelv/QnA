# frozen_string_literal: true

class ReplaceBestAnswerFlagWithAcceptances < ActiveRecord::Migration[8.1]
  def up
    create_table :answer_acceptances do |t|
      t.references :answer, null: false, foreign_key: true, index: { unique: true }
      t.references :question, null: false, foreign_key: true, index: { unique: true }
      t.timestamps
    end

    # One acceptance per question: keep the newest answer flagged as best.
    execute <<~SQL.squish
      INSERT INTO answer_acceptances (answer_id, question_id, created_at, updated_at)
      SELECT DISTINCT ON (question_id) id, question_id, updated_at, updated_at
      FROM answers
      WHERE best_answer = TRUE
      ORDER BY question_id, id DESC
    SQL

    remove_column :answers, :best_answer
  end

  def down
    add_column :answers, :best_answer, :boolean, default: false
    execute 'UPDATE answers SET best_answer = TRUE WHERE id IN (SELECT answer_id FROM answer_acceptances)'
    drop_table :answer_acceptances
  end
end
