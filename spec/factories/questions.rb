# frozen_string_literal: true

FactoryBot.define do
  sequence :title do |n|
    "Question title ##{n} title"
  end

  factory :question do
    user
    title # Same as `title { generate(:title) }`
    body { 'MyBody' }

    trait :invalid do
      title { nil }
    end
  end
end
