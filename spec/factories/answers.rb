# frozen_string_literal: true

include ActionDispatch::TestProcess
FactoryBot.define do
  # sequence :body do |n|
  #   "Answer_number#{n}"
  # end

  factory :answer do
    user
    question
    best_answer { false }
    sequence(:body) { |n| "Answer_number#{n}" }
    # body # Same as `body { generate(:body) }`  if you need sequence not only for one factory

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      before :create do |answer|
        answer.files.attach fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'))
      end
    end

    trait :with_files do
      before :create do |answer|
        answer.files.attach fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'))
        answer.files.attach fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb'))
      end
    end

    trait :with_link do
      before :create do |answer|
        create(:link, linkable: answer)
      end
    end

    trait :with_links do
      before :create do |answer|
        create_list(:link, 2, linkable: answer)
      end
    end
  end
end
# https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md
