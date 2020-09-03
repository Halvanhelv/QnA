class Subscriptions < ActiveRecord::Migration[6.0]
  create_table :subscriptions do |t|
    t.references :user, null: false, foreign_key: true

    t.belongs_to :subscribable, polymorphic: true # аналог reference
    t.timestamps
  end
end
