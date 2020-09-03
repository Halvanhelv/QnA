class ReputationJob < ApplicationJob
  queue_as :default

  def perform(question, answer)
    Services::NewAnswerNotification.new.send_email(question, answer)
  end
end
