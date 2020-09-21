# frozen_string_literal: true

module Services
  class NewAnswerNotification
    def send_notification(answer)
      answer.question.subscribers.find_each(batch_size: 500).each do |user|
        if user.author_of?(answer.question)
          NewAnswerNotificationMailer.notification_for_owner(user, answer).deliver_later unless user.author_of?(answer)
        else
          NewAnswerNotificationMailer.notification_for_user(user, answer).deliver_later unless user.author_of?(answer)
        end
      end
    end
  end
end
