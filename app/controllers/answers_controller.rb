# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :answer

  authorize_resource

  def create
    answer.user = current_user

    if answer.save
      respond_to do |format|
        format.turbo_stream { render :form_reset }
        format.html { redirect_to question }
      end
    else
      render :form_errors, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if answer.update(answer_params)
      respond_to do |format|
        format.turbo_stream { render :replace }
        format.html { redirect_to answer.question }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    answer.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to answer.question, notice: 'Answer successfully deleted.' }
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : question.answers.build(answer_params)
  end
  helper_method :answer

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end
  helper_method :question

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end
end
