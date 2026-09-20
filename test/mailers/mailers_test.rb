# frozen_string_literal: true

require 'test_helper'

class MailersTest < ActionMailer::TestCase
  test 'daily digest lists recent questions' do
    mail = DailyDigestMailer.digest(users(:alice))

    assert_equal ['alice@example.com'], mail.to
    assert_equal 'List of new questions per day:', mail.subject
    assert_match questions(:rails).title, mail.body.encoded
  end

  test 'notification for a subscriber' do
    mail = NewAnswerNotificationMailer.notification_for_user(users(:bob), answers(:step_by_step))

    assert_equal ['bob@example.com'], mail.to
    assert_match answers(:step_by_step).body, mail.body.encoded
  end

  test 'notification for the question owner' do
    mail = NewAnswerNotificationMailer.notification_for_owner(users(:alice), answers(:step_by_step))

    assert_equal ['alice@example.com'], mail.to
    assert_match questions(:rails).title, mail.subject
  end
end
