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
      files { [fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper/rb')] }
    end

    trait :with_files do
      files { [fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper/rb'), fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb'), 'spec_helper/rb')] }
    end

  end
end
