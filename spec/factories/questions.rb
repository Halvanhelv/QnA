# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'MyTitle' }
    body { 'MyBody' }

    trait :invalid do
      title { nil }
    end
  end
end
