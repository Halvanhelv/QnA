FactoryBot.define do
  factory :link do
    association :linkable
    sequence(:name) { |n| "Link_name#{n}" }
    url { 'https://gist.github.com/SynthesisOne/999ecc10ac745e4f7a3a00ff5b038767' }
  end
end
