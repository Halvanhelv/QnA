module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[positive_vote negative_vote] # except is the opposite: only

    def positive_vote
      @votable.user_vote(current_user) <= 0 ? vote(1) : cancel_vote
      end

    def negative_vote
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
      if current_user.author_of?(@votable)

        render json: { error: 'You cannot vote for yourself' }, status: 422
      else
        @votable.formation_vote(current_user, number)
        render json: { id: @votable.id, type: votable_name(@votable), rating: @votable.rating, message: 'You have successfully voted' }
      end
    end

    def votable_name(obj)
      obj.class.name.downcase
    end

    def cancel_vote
      @votable.user_voted(current_user).destroy_all
      render json: { id: @votable.id, type: votable_name(@votable), rating: @votable.rating, message: 'You canceled your vote' }
    end
  end
end