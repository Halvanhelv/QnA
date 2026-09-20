# frozen_string_literal: true

class NewAnswerNotificationMailerPreview < ActionMailer::Preview
  def notification_for_owner = NewAnswerNotificationMailer.notification_for_owner(answer.question.user, answer)
  def notification_for_user = NewAnswerNotificationMailer.notification_for_user(User.first, answer)

  private

  def answer = Answer.first
end
