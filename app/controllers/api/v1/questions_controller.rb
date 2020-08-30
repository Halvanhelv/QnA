class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :question, only: %i[show update destroy]
  authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      head :ok
    else
      head 422
    end
  end

  def update
    if question.update(question_params)
      head :ok
    else
      head 422
    end
  end

  def destroy
    if question.destroy
      head :ok
    else
      head 422
      end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
                                     links_attributes: %i[name url])
  end

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end
end
