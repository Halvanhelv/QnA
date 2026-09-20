# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :question, except: %i[index create]

  include Voted

  authorize_resource

  def index
    @questions = Question.includes(:user)
  end

  def show
    answer.links.new
  end

  def new
    question.links.new
    question.build_reward
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if question.update(question_params)
      respond_to do |format|
        # The updated question reaches every viewer, the author included, through the Turbo Stream broadcast.
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('flash', partial: 'shared/flash',
                                                            locals: { flash: { notice: 'Your question successfully updated.' } })
        end
        format.html { redirect_to question, notice: 'Your question successfully updated.' }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: 'Question successfully deleted.'
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

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: %i[id name url _destroy],
                                                    reward_attributes: %i[name img])
  end
end
