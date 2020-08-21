# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show] # except is the opposite: only
  before_action :answer, except: %i[new show edit]
  include Voted

  authorize_resource

  def create
    answer.user = current_user
    answer.save
    files_params
    if answer.save
      redirect_to answer.question
    else # если отправить пустой ответ то нужно как то передать обьект самого вопроса для редиректа обратно на ту же страницу и вывода ошибок
      render 'questions/show'
    end
  end

  def new; end

  def show; end

  def edit; end

  def update
    answer.update(answer_params)
    files_params
  end

  def destroy
    answer.destroy
    flash[:delete] = 'Answer successfully deleted.'
  end

  def best_answer
    authorize! :best_answer, answer
    answer.make_best_answer
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : answers.build(answer_params)
  end
  helper_method :answer

  def answers
    @answers ||= question.reload.answers
  end
  helper_method :answers

  def answer_params
    params.require(:answer).permit(:body,
                                   links_attributes: %i[name url])
  end

  def question
    @question = Question.with_attached_files.find(params[:question_id])
  end
  helper_method :question

  def files_params
    if params[:answer][:files].present?
      params[:answer][:files].each do |file|
        answer.files.attach(file)
      end
    end
  end
end
