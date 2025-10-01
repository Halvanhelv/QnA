# frozen_string_literal: true

include ActionDispatch::TestProcess
FactoryBot.define do
  factory :reward do
    question
    user

    sequence(:name) { |n| "Reward_name_#{n}" }
    img { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'images', 'reward.png'), 'image/png') }
  end
end
