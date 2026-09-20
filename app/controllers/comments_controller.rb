# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :commentable

  authorize_resource

  def new
    @comment = commentable.comments.new
  end

  def create
    @comment = commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.turbo_stream # the comment itself arrives through the question's Turbo Stream broadcast
        format.html { redirect_to question }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def commentable
    @commentable ||= commentable_class.find(params[:"#{commentable_class.model_name.singular}_id"])
  end
  helper_method :commentable

  def commentable_class
    { 'questions' => Question, 'answers' => Answer }.fetch(params[:commentable])
  end

  def question
    commentable.is_a?(Question) ? commentable : commentable.question
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
