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
    trait :static do
      body { 'TEXT11' }
    end
  end
end
