class QuestionsChannel < ApplicationCable::Channel
  def question
    stream_from 'questions'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
