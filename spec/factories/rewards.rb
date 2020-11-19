# frozen_string_literal: true

FactoryBot.define do
  factory :reward do
    question
    user

    sequence(:name) { |n| "Reward_name_#{n}" }
    img { fixture_file_upload(Rails.root.join('spec', 'images', 'reward.png')) }
  end
end
