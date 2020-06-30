# frozen_string_literal: true

FactoryBot.define do
  sequence :body do |n|
    "Answer_number#{n}"
  end

  factory :answer do
    body
    trait :invalid do
      body { nil }
    end
  end
end
