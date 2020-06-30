# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show] # except за исключением
  def create
    answer.user = current_user
    if answer.save
      redirect_to answer.question
    else # если отправить пустой ответ то нужно как то передать обьект самого вопроса для редиректа обратно на ту же страницу и вывода ошибок
      # redirect_to @answer.question

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
    if current_user.author_of?(answer)
      answer.destroy
      flash[:delete] = 'Answer successfully deleted.'
    else
      flash[:question] = "You cannot delete someone else's answer"
    end
    redirect_to answer.question
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : answers.build(answer_params)
  end
  helper_method :answer

  def answers
    @answers ||= question.reload.answers
  end
  helper_method :answers

  def answer_params
    params.require(:answer).permit(:body)
  end

  def question
    @question = Question.find(params[:question_id])
  end
  helper_method :question
end
