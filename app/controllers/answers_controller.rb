# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show] # except is the opposite: only

  def create
    answer.user = current_user
    answer.save
    # if answer.save
    #   redirect_to answer.question
    # else # если отправить пустой ответ то нужно как то передать обьект самого вопроса для редиректа обратно на ту же страницу и вывода ошибок
    #   render 'questions/show'
    # end
  end

  def new; end

  def show; end

  def edit; end

  def update
    answer.update(answer_params) if current_user.author_of?(answer)
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      flash[:delete] = 'Answer successfully deleted.'
    else
      flash[:question] = "You cannot delete someone else's answer"
    end
  end

  def best_answer
    answer.make_best_answer if current_user.author_of?(answer.question)
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
