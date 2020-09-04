class NewAnswerNotificationMailer < ApplicationMailer
  def notification_for_user(user, answer)
    @question = answer.question.title
    @answer = answer.body
    @greeting = "Hello, #{user.email}"
    mail(to: user.email, subject: "New #{@question} answers")
  end

  def notification_for_owner(user, answer)
    @question = answer.question.title
    @answer = answer.body
    @greeting = "Hello, #{user.email}"
    mail(to: user.email, subject: "New answer for your question: #{@question}: #{@answer}")
  end
end
