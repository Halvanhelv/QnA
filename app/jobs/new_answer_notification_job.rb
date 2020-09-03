class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::NewAnswerNotification.new.send_notification(answer)
  end
end
