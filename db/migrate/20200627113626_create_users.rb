# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, on_delete: :cascade, &:timestamps

  end
end
