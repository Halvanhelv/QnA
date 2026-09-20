# frozen_string_literal: true

require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  test 'a user subscribes to a question only once' do
    duplicate = Subscription.new(user: users(:alice), question: questions(:rails))
    assert_not duplicate.valid?
  end
end
