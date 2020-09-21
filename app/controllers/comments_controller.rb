# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment, only: %i[create]

  authorize_resource

  def create
    @comment = set_commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast("question_#{question_id}_comments",
                                 id: @commentable.id,
                                 type: @commentable.class.name.underscore,
                                 author: @comment.user.email,
                                 comment: @comment)
  end

  def question_id
    if set_commentable.class == Question
      set_commentable.id
    else
      set_commentable.question.id
    end
  end

  def set_commentable
    @commentable = commentable_name.classify.constantize.find(parent_id)
  end

  def parent_id
    request.path.split('/')[2]
  end

  def commentable_name
    params[:commentable]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
