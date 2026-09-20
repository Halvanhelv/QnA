# frozen_string_literal: true

require 'test_helper'

class SubscriptionsTest < ActionDispatch::IntegrationTest
  test 'subscribes and swaps the subscription button' do
    sign_in users(:alice)
    question = questions(:hotwire)

    assert_difference -> { question.subscriptions.count } => 1 do
      post question_subscriptions_path(question), headers: turbo_headers
    end

    assert_turbo_stream action: 'replace', target: 'question-subscription'
  end

  test 'unsubscribes' do
    sign_in users(:alice)

    assert_difference -> { Subscription.count } => -1 do
      delete subscription_path(subscriptions(:alice_rails)), headers: turbo_headers
    end
  end

  test "cannot remove someone else's subscription" do
    sign_in users(:alice)

    assert_no_difference -> { Subscription.count } do
      delete subscription_path(subscriptions(:bob_hotwire)), headers: turbo_headers
    end
  end
end
