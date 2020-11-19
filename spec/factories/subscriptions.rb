# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    question { question }
    user { user }
  end
end
