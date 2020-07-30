class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
  end

  def question(data)
    stream_from "question#{data[:question_id]}"
  end
  def questions
    stream_from 'questions'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
