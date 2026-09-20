# frozen_string_literal: true

require 'test_helper'

class RewardTest < ActiveSupport::TestCase
  test 'requires a name and an image' do
    reward = Reward.new(question: questions(:rails))
    assert_not reward.valid?
    assert_includes reward.errors.attribute_names, :name
    assert_includes reward.errors.attribute_names, :img
  end
end
