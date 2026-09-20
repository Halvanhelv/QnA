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
    assert_match answers(:step_by_step).plain_body, mail.body.encoded
  end

  test 'notification for the question owner' do
    mail = NewAnswerNotificationMailer.notification_for_owner(users(:alice), answers(:step_by_step))

    assert_equal ['alice@example.com'], mail.to
    assert_match questions(:rails).title, mail.subject
  end

  test 'app mails are multipart and share the branded layout' do
    mail = NewAnswerNotificationMailer.notification_for_owner(users(:alice), answers(:step_by_step))

    assert_equal 2, mail.parts.size
    html = mail.html_part.body.decoded
    text = mail.text_part.body.decoded

    assert_includes html, '#3347ff'
    assert_includes html, 'Read the answer'
    assert_includes html, "question_url(#{questions(:rails).id})".then { "/questions/#{questions(:rails).id}#answer_#{answers(:step_by_step).id}" }
    assert_includes text, 'Read the answer:'
    assert_includes text, questions(:rails).title
  end

  test 'digest lists every recent question with a link and its author' do
    mail = DailyDigestMailer.digest(users(:alice))
    html = mail.html_part.body.decoded

    Question.recent.each do |question|
      assert_includes html, question.title
      assert_includes html, "/questions/#{question.id}"
    end
    assert_includes mail.text_part.body.decoded, questions(:rails).title
  end

  test 'devise mails use the app layout and are multipart' do
    mail = Devise::Mailer.confirmation_instructions(users(:alice), 'token123')

    assert_equal 2, mail.parts.size
    assert_includes mail.html_part.body.decoded, 'Confirm email'
    assert_includes mail.html_part.body.decoded, '#3347ff'
    assert_includes mail.html_part.body.decoded, 'confirmation_token=token123'
    assert_includes mail.text_part.body.decoded, 'confirmation_token=token123'
  end

  test 'password reset mail carries the reset link' do
    mail = Devise::Mailer.reset_password_instructions(users(:alice), 'reset123')

    assert_includes mail.html_part.body.decoded, 'reset_password_token=reset123'
    assert_includes mail.html_part.body.decoded, 'Change password'
  end
end

class DailyDigestServiceTest < ActiveSupport::TestCase
  test 'sends nothing when no questions were asked in the last day' do
    Question.update_all(created_at: 3.days.ago)

    assert_no_enqueued_jobs(only: ActionMailer::MailDeliveryJob) { Services::DailyDigest.new.send_digest }
  end
end
