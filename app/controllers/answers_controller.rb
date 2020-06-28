# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show] #except за исключением
  def create

    @answer = question.answers.new(answer_params)
    if @answer.save
      redirect_to @answer.question
    else
      # redirect_to @answer.question
      @question = @answer.question # если отправить пустой ответ то нужно как то передать обьект самого вопроса для редиректа обратно на ту же страницу и вывода ошибок
      render 'questions/show'

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