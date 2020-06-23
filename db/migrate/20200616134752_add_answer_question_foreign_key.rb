class AddAnswerQuestionForeignKey < ActiveRecord::Migration[6.0]

  def up
    add_reference(:answers, :question, null: false, foreign_key: true, on_delete: :cascade, index: true)
  end

  def down
    remove_foreign_key(:answers, :question)
  end
end
