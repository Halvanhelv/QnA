# frozen_string_literal: true

class NewAnswerNotificationMailer < ApplicationMailer
  def notification_for_user(user, answer)
    prepare(answer)
    mail(to: user.email, subject: "New #{@question.title} answers")
  end

  def notification_for_owner(user, answer)
    prepare(answer)
    mail(to: user.email, subject: "New answer for your question: #{@question.title}: #{@excerpt}")
  end

  private

  def prepare(answer)
    @question = answer.question
    @author = answer.user.email
    @excerpt = answer.plain_body.truncate(400)
    @url = question_url(@question, anchor: ActionView::RecordIdentifier.dom_id(answer))
  end
end
