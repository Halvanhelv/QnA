# frozen_string_literal: true

# Casts the vote of `score` on a question or an answer; voting the same way again takes the vote back.
module Voting
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, :set_votable
  end

  def create
    authorize! :vote, @votable
    respond_with_rating @votable.toggle_vote(current_user, score)
  end

  private

  def set_votable
    @votable = params[:question_id] ? Question.find(params[:question_id]) : Answer.find(params[:answer_id])
  end

  def vote_question
    @votable.is_a?(Question) ? @votable : @votable.question
  end

  def respond_with_rating(voted)
    message = voted ? 'You have successfully voted' : 'You canceled your vote'

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace(helpers.dom_id(@votable, :votes), partial: 'shared/votes',
                                                                 locals: { resource: @votable, score: @votable.score_by(current_user) }),
          turbo_stream.update('my-votes', helpers.my_votes_json(vote_question)),
          turbo_stream_flash(notice: message)
        ]
      end
      format.json do
        render json: { id: @votable.id, type: @votable.class.name.downcase, rating: @votable.rating, message: message }
      end
      format.html { redirect_back_or_to root_path, notice: message }
    end
  end
end
