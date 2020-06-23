class AnswersController < ApplicationController
  before_action :load_question, only: %i[show edit update destroy create]
  def create

    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to question_answer_path(@question, @answer)
    else
      render :new
    end
  end

  def show; end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_question

    @question = Question.find(params[:question_id])
  end

end
