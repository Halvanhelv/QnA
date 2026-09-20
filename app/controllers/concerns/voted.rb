# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[positive_vote negative_vote]
  end

  def positive_vote
    authorize! :positive_vote, @votable
    @votable.user_vote(current_user) <= 0 ? vote(1) : cancel_vote
  end

  def negative_vote
    authorize! :negative_vote, @votable
    @votable.user_vote(current_user) >= 0 ? vote(-1) : cancel_vote
  end

  private

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def vote(number)
    @votable.formation_vote(current_user, number)
    respond_with_rating('You have successfully voted')
  end

  def cancel_vote
    @votable.user_voted(current_user).destroy_all
    respond_with_rating('You canceled your vote')
  end

  def respond_with_rating(message)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(helpers.dom_id(@votable, :rating), @votable.rating.to_s),
          turbo_stream.update('flash', partial: 'shared/flash', locals: { flash: { notice: message } })
        ]
      end
      format.json do
        render json: { id: @votable.id, type: @votable.class.name.downcase, rating: @votable.rating, message: message }
      end
      format.html { redirect_back_or_to root_path, notice: message }
    end
  end
end
