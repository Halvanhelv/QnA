# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[8.1]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.integer :taggings_count, null: false, default: 0
      t.timestamps
    end
    add_index :tags, :name, unique: true

    create_table :taggings do |t|
      t.references :question, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.timestamps
    end
    add_index :taggings, %i[question_id tag_id], unique: true
  end
end
