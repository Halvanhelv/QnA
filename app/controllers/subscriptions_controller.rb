# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :question, only: :create
  before_action :subscription, only: :destroy

  authorize_resource

  def create
    question.subscribe(current_user)
    respond_with_subscription
  end

  def destroy
    @question = subscription.question
    subscription.destroy
    respond_with_subscription
  end

  private

  def respond_with_subscription
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('question-subscription', partial: 'subscriptions/subscriptions',
                                                                            locals: { question: @question })
      end
      format.html { redirect_to @question }
    end
  end

  def question
    @question = Question.find(params[:question_id])
  end

  def subscription
    @subscription = Subscription.find(params[:id])
  end
end
