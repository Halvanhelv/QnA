FactoryBot.define do
  factory :comment do

    sequence(:body) { |n| "comment_______#{n}" }
  end

  trait :invalid do
    body { nil }
  end
end
