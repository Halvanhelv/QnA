# frozen_string_literal: true

FactoryBot.define do
  factory :oauth_provider do
    user { nil }
    provider { 'MyString' }
    uid { 'MyString' }
  end
end
