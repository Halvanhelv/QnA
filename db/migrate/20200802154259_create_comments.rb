# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :body, null: false
      t.belongs_to :commentable, polymorphic: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
