# frozen_string_literal: true

class AnswersController < ApplicationController
  def create
    @answer = question.answers.new(answer_params)
    if @answer.save
      redirect_to answer_path(@answer)
    else
      render :new
    end
  end

  def new; end

  def show; end

  def edit; end

  def update
    if answer.update(answer_params)
      redirect_to answer
    else
      render :edit
    end
  end

  def destroy
    redirect_to answer.question if answer.destroy
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body)
  end

  def question
    @question = Question.find(params[:question_id])
  end
end