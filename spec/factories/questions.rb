# frozen_string_literal: true
include ActionDispatch::TestProcess
FactoryBot.define do
  sequence :title do |n|
    "Question title ##{n} title"
  end

  factory :question do
    user
    title # Same as `title { generate(:title) }`
    body { 'MyBody' }


    trait :invalid do
      title { nil }
    end

    trait :with_file do
      before :create do |question|
        question.files.attach fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'))
      end
    end

    trait :with_files do
      before :create do |question|
        question.files.attach fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'))
        question.files.attach fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb'))
      end
    end 

  end
end
