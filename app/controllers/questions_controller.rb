# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show] # except за исключением
  def index
    @questions = Question.all
  end

  def show; end

  def new
    question
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question
    else
      render :edit
    end
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
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
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
    params.require(:question).permit(:title, :body)
  end
end
