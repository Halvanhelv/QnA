# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email # Same as `email   { generate(:email) }`
    password { '123456' }
    password_confirmation { '123456' }
  end
end
# Note that defining sequences as implicit attributes will not work if you have a factory with the same name as the sequence
