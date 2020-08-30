class Api::V1::AnswersController < Api::V1::BaseController
  before_action :answer, only: %i[show update destroy]
  before_action :answers, only: %i[index create]

  authorize_resource

  def index
    render json: answers, each_serializer: AnswersSerializer
  end

  def show
    render json: answer
  end

  def create
    authorize! :create, question

    @answer = question.answers.new(answer_params)
    @answer.user = current_resource_owner
    if @answer.save
      head :ok
    else
      head 422
    end
  end

  def update
    if answer.update(answer_params)
      head :ok
    else
      head 422
    end
  end

  def destroy
    if answer.destroy
      head :ok
    else
      head 422
    end
  end

  private

  def answers
    @answers ||= question.reload.answers
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : answers.build(answer_params)
  end

  def answer_params
    params.require(:answer).permit(:body,
                                   links_attributes: %i[name url])
  end

  def question
    @question = Question.with_attached_files.find(params[:question_id])
  end
end
