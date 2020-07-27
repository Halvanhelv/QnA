module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable

    def rating
      votes.sum(:score)
    end

    def user_vote(user)
      user_voted(user).sum(:score)
    end

    def user_voted(user)
      votes.where(user_id: user.id)
    end

    def formation_vote(user, number)

      user_voted(user).any? ? user_voted(user).first.update(score: number) : votes.create(score: number, user: user)

    end

  end
end
