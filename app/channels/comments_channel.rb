class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    unfollow
    stream_from "question_#{data['id']}_comments"

  end

  def unfollow
    stop_all_streams
  end
end
