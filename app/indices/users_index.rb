# frozen_string_literal: true

ThinkingSphinx::Index.define :user, with: :active_record do
  indexes email

  has created_at
end
