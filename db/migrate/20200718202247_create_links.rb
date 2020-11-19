# frozen_string_literal: true

class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links do |t|
      t.string :name
      t.string :url
      t.belongs_to :linkable, polymorphic: true # аналог reference
      t.timestamps
    end
  end
end
