class Services::NewAnswerNotification
  def send_notification(answer)
    answer.question.subscribers.find_each(batch_size: 500).each do |user|
      NewAnswerNotificationMailer.notification_for_user(user, answer).try(:deliver_later) unless answer.user == user
    end
  end
end
