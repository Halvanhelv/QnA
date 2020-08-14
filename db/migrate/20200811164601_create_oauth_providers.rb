class CreateOauthProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :oauth_providers do |t|
      t.references :user, null: false, foreign_key: true, on_delete: :cascade
      t.string :provider
      t.string :uid

      t.timestamps
    end
    add_index :oauth_providers, %i[provider uid]
  end
end
