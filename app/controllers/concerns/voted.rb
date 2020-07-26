module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[positive_vote negative_vote] # except is the opposite: only

    def positive_vote
      user_vote <= 0 ? vote(1) : cancel_vote
      end

    def negative_vote
      user_vote >= 0 ? vote(-1) : cancel_vote
    end

    private

    def set_votable
      @votable = model_klass.find(params[:id])
    end

    def model_klass
      controller_name.classify.constantize
    end

    def vote(number)
      if current_user.author_of?(@votable)
        render json: { error: 'You cannot vote for yourself' }, status: 422
      else
        user_voted.any? ? user_voted.first.update(score: number) : @votable.votes.create(score: number, user: current_user)
        render json: { id: @votable.id, type: votable_name(@votable), rating: @votable.rating, message: 'You have successfully voted' }
    end
    end

    def user_vote
      user_voted.sum(:score)
    end

    def votable_name(obj)
      obj.class.name.downcase
    end

    def user_voted
      @votable.votes.where(user_id: current_user.id)
    end
    def cancel_vote
      user_voted.destroy_all
      render json: { id: @votable.id, type: votable_name(@votable), rating: @votable.rating, message: 'You canceled your vote' }
    end
  end
end
