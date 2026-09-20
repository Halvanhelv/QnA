# frozen_string_literal: true

require 'test_helper'

class NotificationsTest < ActiveSupport::TestCase
  test 'daily digest mails every user' do
    assert_enqueued_jobs User.count, only: ActionMailer::MailDeliveryJob do
      Services::DailyDigest.new.send_digest
    end
  end

  test 'new answer notification skips the answer author and reaches other subscribers' do
    question = questions(:rails)
    answer = question.answers.create!(body: 'Yet another answer', user: users(:bob))
    question.subscriptions.create!(user: users(:bob))
    clear_enqueued_jobs

    assert_enqueued_jobs 1, only: ActionMailer::MailDeliveryJob do
      Services::NewAnswerNotification.new.send_notification(answer)
    end
  end
end
