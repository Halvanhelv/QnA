# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show] # except is the opposite: only

  include Voted

  def index
    @questions = Question.all
  end

  def show
    answer.links.new # build создаем связанный объект
    gon.question_id = question.id
  end

  def new
    question
    question.links.new # build создаем связанный объект
    question.build_reward
  end

  def create
    redirect_to new_user_session_path unless current_user
    @question = current_user.questions.new(question_params)
    files_params

    if @question.save
      ActionCable.server.broadcast('questions',
                                    id: question.id,
                                    title: question.title)

      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params) if current_user.author_of?(question)
    files_params

  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      flash[:delete] = 'Question successfully deleted.'
    else
      flash[:question] = "You cannot delete someone else's question"
    end
    redirect_to questions_path
  end

  private

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
  # def load_question
  #   @question = Question.find(params[:id])
  # end

  def question_params
    params.require(:question).permit(:title, :body,
                                     links_attributes: %i[name url],
                                     reward_attributes: %i[name img])
  end

  def files_params
    if params[:question][:files].present?
      params[:question][:files].each do |file|
        question.files.attach(file)
      end
      end
  end
end
