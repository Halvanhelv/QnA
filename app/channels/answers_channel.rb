class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    unfollow
    stream_from "answers_for_question_#{data['id']}"
  end

  def unfollow
    stop_all_streams
  end
end


