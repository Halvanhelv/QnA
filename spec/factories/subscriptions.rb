FactoryBot.define do
  factory :subscription do
    association :subscribable, factory: :question
    user { user }
  end
end
