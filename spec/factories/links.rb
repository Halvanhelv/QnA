# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    association :linkable, factory: :question
    sequence(:name) { |n| "Link_name#{n}" }
    url { 'https://google.com' }
  end
end
