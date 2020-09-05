class Services::NewAnswerNotification
  def send_notification(answer)
    answer.question.subscribers.find_each(batch_size: 500).each do |user|
      if user.author_of?(answer.question)
        unless user.author_of?(answer)
          NewAnswerNotificationMailer.notification_for_owner(user, answer).try(:deliver_later)
        end
      else
        unless user.author_of?(answer)
          NewAnswerNotificationMailer.notification_for_user(user, answer).try(:deliver_later)
        end
      end
    end
  end
end
