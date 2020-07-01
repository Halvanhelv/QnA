# frozen_string_literal: true

FactoryBot.define do
  sequence :body do |n|
    "Answer_number#{n}"
  end

  factory :answer do
    association :user
    association :question
    body
    trait :invalid do
      body { nil }
    end
  end
end
