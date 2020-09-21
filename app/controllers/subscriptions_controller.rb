# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :question, only: :create
  before_action :subscription, only: :destroy

  authorize_resource

  def create
    question.subscriptions.create(user_id: current_user.id)
  end

  def destroy
    @question = subscription.question
    subscription.destroy
  end

  private

  def question
    @question = Question.find(params[:question_id])
  end
  helper_method :question

  def subscription
    @subscription = Subscription.find(params[:id])
  end
end
