# frozen_string_literal: true

class AcceptancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer

  def create
    authorize! :accept, @answer
    @answer.accept

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('answers', partial: 'answers/list', locals: { question: @answer.question })
      end
      format.html { redirect_to @answer.question }
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:answer_id])
  end
end
