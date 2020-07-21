class RewardForBestAnswerAuthor < ActiveRecord::Migration[6.0]
  def change
    create_table :rewards do |t|
      t.string :name, null: false
      t.references :question, null: false, foreign_key: true
      t.references :user, default: nil, foreign_key: true
      t.timestamps
    end
  end
end
