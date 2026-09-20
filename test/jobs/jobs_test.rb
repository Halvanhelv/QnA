# frozen_string_literal: true

require 'test_helper'

class JobsTest < ActiveJob::TestCase
  test 'DailyDigestJob delegates to the digest service' do
    called = false
    digest = Object.new
    digest.define_singleton_method(:send_digest) { called = true }

    Services::DailyDigest.stub(:new, digest) { DailyDigestJob.perform_now }

    assert called
  end

  test 'NewAnswerNotificationJob delegates to the notification service' do
    answer = answers(:step_by_step)
    received = nil
    service = Object.new
    service.define_singleton_method(:send_notification) { |arg| received = arg }

    Services::NewAnswerNotification.stub(:new, service) { NewAnswerNotificationJob.perform_now(answer) }

    assert_equal answer, received
  end
end
