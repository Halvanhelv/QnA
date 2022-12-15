# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :gon_variables, only: :show
  before_action :question, except: %i[index create]

  include Voted

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    answer.links.new
  end

  def new
    question
    question.links.new
    question.build_reward
  end

  def create
    @question = current_user.questions.new(question_params)
    files_params

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
    files_params
  end

  def destroy
    question.destroy
    flash[:delete] = 'Question successfully deleted.'
    redirect_to questions_path
  end

  private

  def gon_variables
    gon.question_id = question.id
    gon.question_owner_id = question.user.id
  end

  def answer
    @answer ||= question.answers.new
  end
  helper_method :answer

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def answers
    @answers ||= question.reload.answers
  end

  helper_method :answers

  def question_params
    params.require(:question).permit(:title, :body,
                                     links_attributes: %i[name url],
                                     reward_attributes: %i[name img])
  end

  def files_params
    return unless params[:question][:files].present?

    params[:question][:files].each do |file|
      question.files.attach(file)
    end
  end
end
