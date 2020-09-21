# frozen_string_literal: true

class QuestionsChannel < ApplicationCable::Channel
  def follow
    unfollow
    stream_from 'questions'
  end

  def unfollow
    stop_all_streams
  end
end
