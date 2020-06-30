# frozen_string_literal: true

FactoryBot.define do
  # sequence :body do |n|
  #   "Answer_number#{n}"
  # end

  factory :answer do
    user
    question

    sequence(:body) { |n| "Answer_number#{n}" }
    # body # Same as `body { generate(:body) }`  if you need sequence not only for one factory
    #
    trait :invalid do
      body { nil }
    end
  end
end
# https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md
